#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'colorize'
require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.css('.column2 table td a/@href').each do |href|
    link = URI.join url, href
    scrape_person(link)
  end
end

def scrape_person(url)
  noko = noko_for(url)
  box = noko.css('div.column2')
  data = { 
    id: url.to_s.split('/').last,
    name: box.css('h1').text.split(' - ').first.sub('Hon. ','').sub(' MP','').tidy,
    faction: box.xpath('.//p[strong[contains(.,"Parliamentary Group:")]]//img/@title').text,
    email: box.css('a[href*="mailto:"]/@href').text.split('mailto:').drop(1).first,
    image: box.css('img/@src').first.text,
    term: 12,
    source: url.to_s,
  }
  data[:image] = URI.join(url, data[:image]).to_s unless data[:image].to_s.empty?
  ScraperWiki.save_sqlite([:id, :term], data)
end

scrape_list('http://www.parlament.mt/membersofparliament?l=1')
