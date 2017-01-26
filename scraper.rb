#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraperwiki'

require_rel 'lib'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

start = 'http://www.parlament.mt/membersofparliament?l=1'
data = scrape(start => MembersPage).member_urls.map do |url|
  scrape(url => MemberPage).to_h
                           .reject { |k, _v| k == :electoral_history }
                           .merge(term: 12)
end

# puts data
ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
ScraperWiki.save_sqlite(%i(id term), data)
