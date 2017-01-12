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
    box.css('img/@src').first.text rescue nil
  end

  field :source do
    url.to_s
  end

  private

  def box
    noko.css('div.column2')
  end
end

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

def ex_members_urls
  [
    'http://www.parlament.mt/brincat-leo',
    'http://www.parlament.mt/joe-cassar',
    'http://www.parlament.mt/fenech-albert',
  ]
end

start = 'http://www.parlament.mt/membersofparliament?l=1'
data = (
  scrape(start => MembersPage).member_urls +
  ex_members_urls
).map do |url|
  scrape(url => MemberPage).to_h.merge(term: 12)
end

# puts data
ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
ScraperWiki.save_sqlite(%i(id term), data)
