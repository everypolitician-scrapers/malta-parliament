# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/ex_member_page.rb'

describe ExMemberPage do
  around { |test| VCR.use_cassette(url.split('/').last.split('-').map(&:capitalize).join(''), &test) }

  let(:yaml_data) { YAML.load_file(subject) }
  let(:url)       { yaml_data[:url] }
  let(:response)  { ExMemberPage.new(response: Scraped::Request.new(url: url).response) }

  describe 'ex member with prefix' do
    subject { 'test/data/joe-cassar.yml' }

    it 'gets the expected data' do
      response.to_h.must_equal yaml_data[:to_h]
    end
  end

  describe 'ex member without prefix' do
    subject { 'test/data/brincat-leo.yml' }

    it 'gets the expected data' do
      response.to_h.must_equal yaml_data[:to_h]
    end
  end
end
