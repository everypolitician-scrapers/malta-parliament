# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe 'George Vella' do
  around { |test| VCR.use_cassette('GeorgeVella', &test) }

  subject do
    url = 'http://www.parlament.mt/vella-george'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral data' do
    it 'should have the correct start date' do
      subject.start_date.must_equal '2013-03-11'
    end

    it 'should return nil for end date' do
      subject.end_date.must_be_nil
    end
  end
end

describe 'Joe Cassar' do
  around { |test| VCR.use_cassette('JoeCassar', &test) }

  subject do
    url = 'http://www.parlament.mt/joe-cassar'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral data' do
    it 'should return the end date' do
      subject.end_date.must_equal '2015-11-03'
    end
  end
end

describe 'Chris Agius' do
  around { |test| VCR.use_cassette('ChrisAgius', &test) }

  subject do
    url = 'http://www.parlament.mt/agius-chris'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral data' do
    it 'should return start date' do
      subject.start_date.must_equal '2013-03-28'
    end
  end
end
