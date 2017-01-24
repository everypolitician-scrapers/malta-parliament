# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/ex_member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette('GeorgeVella', &test) }

  subject do
    url = 'http://www.parlament.mt/vella-george'
    ExMemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  it 'should have a name field with the name of the member' do
    subject.name.must_equal 'George Vella'
  end

  it 'should respond to electoral_history' do
    subject.must_respond_to :electoral_history
  end
end
