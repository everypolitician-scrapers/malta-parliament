#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraped'
require 'scraperwiki'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

class MembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :member_urls do
    noko.css('.column2 table td a/@href').map(&:text)
  end
end

class MemberPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :id do
    url.to_s.split('/').last
  end

  field :name do
    box.css('h1').text.split(' - ').first.sub('Hon. ', '').sub(' MP', '').tidy
  end

  field :faction do
    f = box.xpath('.//strong[contains(.,"Parliamentary Group")]/..//img/@title').text
    return 'Partit Nazzjonlista' if f == 'PN'
    f
  end

  field :email do
    box.css('a[href*="mailto:"]/@href').text.split('mailto:').drop(1).first
  end

  field :image do
    box.css('img/@src').first.text
  end

  field :source do
    url.to_s
  end

  field :start_date do
    date_from(
      recent_electoral_history
                  .scan(/(?:Elected on|Oath of Allegiance|casual elections on)[^:]*\:\s*(\d{1,2}\.\d{1,2}\.\d{2,4})/)
                  .flatten
                  .last
    )
  end

  field :end_date do
    date_from(
      recent_electoral_history
                  .scan(/(?:Resignation from Parliament)[^:]*\:\s*(\d{1,2}\.\d{1,2}\.\d{2,4})/)
                  .flatten
                  .last
    )
  end

  private

  def box
    noko.css('div.column2')
  end

  def recent_electoral_history
    noko.xpath('//tr[contains(.,"Electoral History")]')
        .text
        .split('Parliament:')
        .last
  end

  def date_from(date)
    return if date.nil?
    Date.strptime(date, '%d.%m.%y').to_s
  end
end

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

start = 'http://www.parlament.mt/membersofparliament?l=1'
data = scrape(start => MembersPage).member_urls.map do |url|
  scrape(url => MemberPage).to_h.merge(term: 12)
end

# puts data
ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
ScraperWiki.save_sqlite(%i(id term), data)
