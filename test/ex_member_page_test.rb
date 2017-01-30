# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/ex_member_page.rb'
require_relative '../lib/decorators/formatted_dates'
require_relative '../lib/electoral_history'

describe MemberPage do
  around { |test| VCR.use_cassette('JoeCassar', &test) }

  subject do
    url = 'http://www.parlament.mt/joe-cassar'
    ExMemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  it 'should have a name field with the name of the member' do
    subject.name.must_equal 'Dr Joe Cassar'
  end

  it 'should respond to electoral_history' do
    subject.must_respond_to :electoral_history
  end
end
