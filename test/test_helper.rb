# frozen_string_literal: true
require 'minitest/autorun'
require 'vcr'
require 'webmock'
require 'minitest/around/spec'

VCR.configure do |c|
  c.cassette_library_dir = 'tests/cassettes'
  c.hook_into :webmock
end
