# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette('GeorgeVella', &test) }

  subject do
    url = 'http://www.parlament.mt/vella-george'
    MemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  it 'should have a name field with the name of the member' do
    subject.name.must_equal 'George Vella'
  end

  it 'should have an electoral history field' do
    subject.must_respond_to :electoral_history
  end

  it 'should return a hash from electoral_history' do
    subject.electoral_history.must_be_kind_of Hash
  end
end
