# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette('MemberPage', &test) }

  subject do
    url = 'http://www.parlament.mt/vella-george'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral data' do
    it 'should have the correct start date' do
      subject.start_date.must_equal '2013-03-11'
    end

    it 'should return nil for end date when no end date is given' do
      subject.end_date.must_be_nil
    end
  end
end
