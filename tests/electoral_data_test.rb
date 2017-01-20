# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'
require_relative '../lib/ex_member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette('MemberPage', &test) }

  subject do
    url = 'http://www.parlament.mt/vella-george'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral history' do
    it 'should be empty' do
      subject.electoral_history.must_be_empty
    end
  end
end

describe 'Joe Cassar' do
  around { |test| VCR.use_cassette('JoeCassar', &test) }

  subject do
    url = 'http://www.parlament.mt/joe-cassar'
    ExMemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'electoral history' do
    it 'should have an end date' do
      require 'pry'
      subject.electoral_history['Twelfth Parliament']['Resignation from Parliament'].must_equal '3.11.15'
    end
  end
end
