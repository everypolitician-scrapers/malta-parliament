# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette('JoeCassar', &test) }

  subject do
    url = 'http://www.parlament.mt/joe-cassar'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  it 'should have a name field with the name of the member' do
    subject.name.must_equal 'Dr Joe Cassar'
  end

  it 'should respond to electoral_history' do
    subject.must_respond_to :electoral_history
  end

  it 'should have an end date for the twelfth term' do
    subject.electoral_history['Twelfth Parliament']['Resignation from Parliament']
           .must_equal '2015-11-03'
  end
end
