# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  subject { MemberPage.new(response: Scraped::Request.new(url: url).response) }
  around { |test| VCR.use_cassette(url.split('/').last.split('-').map(&:capitalize).reverse.join(''), &test) }

  describe 'Dr Albert Fenech' do
    let(:url) { 'http://www.parlament.mt/fenech-albert' }
    it 'should have a name field with the name of the member without a prefix' do
      subject.to_h.must_equal(
        id:                'fenech-albert',
        name:              'Albert Fenech',
        honorific_prefix:  'Dr',
        faction:           '',
        email:             'albert.fenech@gov.mt',
        image:             'http://www.parlament.mt/file.aspx?f=33193',
        source:            'http://www.parlament.mt/fenech-albert',
        electoral_history: {}
      )
    end
  end

  describe 'Ian Borg' do
    let(:url) { 'http://www.parlament.mt/borg-ian' }

    it 'should contain the expected data' do
      subject.to_h.must_equal(
        id:                'borg-ian',
        name:              'Ian Borg',
        honorific_prefix:  '',
        faction:           'Partit Laburista',
        email:             'ian.borg@gov.mt',
        image:             'http://www.parlament.mt/file.aspx?f=31734',
        source:            'http://www.parlament.mt/borg-ian',
        electoral_history: {}
      )
    end
  end
end
