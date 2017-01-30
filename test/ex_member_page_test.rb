# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/ex_member_page.rb'

describe ExMemberPage do
  around { |test| VCR.use_cassette(url.split('/').last.split('-').map(&:capitalize).join(''), &test) }

  subject do
    ExMemberPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'ex member with prefix' do
    let(:url) { 'http://www.parlament.mt/joe-cassar' }

    it 'should have the expected data' do
      subject.to_h.must_equal(
        id:                'joe-cassar',
        name:              'Joe Cassar',
        honorific_prefix:  'Dr',
        faction:           '',
        email:             nil,
        image:             nil,
        source:            'http://www.parlament.mt/joe-cassar',
        electoral_history: { 'Tenth Parliament'    => { 'Co-opted' => '2004-05-24', 'Oath of Allegiance' => '2004-05-24', 'Dissolution of Parliament' => '2008-02-04' },
                             'Eleventh Parliament' =>
                                                      { 'Elected on'                                                                => '2008-03-12',
                                                        'Oath of Allegiance as Parliamentary Secretary for Health'                  => '2008-03-12',
                                                        'Oath of Allegiance as Member'                                              => '2008-05-10',
                                                        'Oath of Allegiance as Minister for Health, the Elderly and Community Care' => '2010-02-10',
                                                        'Ceased as Minister'                                                        => '2013-03-09', },
                             'Twelfth Parliament'  => { 'Elected on' => '2013-03-13', 'Oath of Allegiance' => '2013-04-06', 'Resignation from Parliament' => '2015-11-03' }, }
      )
    end
  end

  describe 'ex member without prefix' do
    let(:url) { 'http://www.parlament.mt/brincat-leo' }

    it 'should have the expected data' do
      subject.to_h.must_equal(
        id:                'brincat-leo',
        name:              'Leo Brincat',
        honorific_prefix:  '',
        faction:           'Partit Laburista',
        email:             'leo.brincat@parlament.mt',
        image:             'http://www.parlament.mt/file.aspx?f=31727',
        source:            'http://www.parlament.mt/brincat-leo',
        electoral_history: { 'Fifth Parliament'    =>
                                                      { 'Elected on' => '1982-01-11', 'Appointed Parliamentary Secretary' => '1986-07-16', 'Dissolution of Parliament' => '1987-02-13' },
                             'Sixth Parliament'    => { 'Elected on' => '1987-05-13', 'Oath of Allegiance' => '1987-07-09', 'Dissolution of Parliament' => '1992-01-20' },
                             'Seventh Parliament'  => { 'Elected in the 9th DivisionOath of Allegiance' => '1992-04-04', 'Dissolution of Parliament' => '1996-09-23' },
                             'Eighth Parliament'   => { 'Elected on' => '1996-10-29', 'Appointed Ministry of Commerce' => '1998-09-07' },
                             'Ninth Parliament'    => { 'Elected on' => '1998-09-08', 'Oath of Allegiance' => '1998-10-24', 'Dissolution of Parliament' => '2003-03-10' },
                             'Tenth Parliament'    => { 'Elected on' => '2003-04-14', 'Oath of Allegiance' => '2003-05-24', 'Dissolution of Parliament' => '2008-02-04' },
                             'Eleventh Parliament' => { 'Elected on' => '2008-03-12', 'Oath of Allegiance' => '2008-05-10', 'Dissolution of Parliament' => '2013-01-07' },
                             'Twelfth Parliament'  =>
                                                      { 'Elected on'                                                                           => '2013-03-11',
                                                        'Sworn in as Minister for the Environment, Sustainable Development and Climate Change' => '2013-03-13',
                                                        'Oath of Allegiance as MP'                                                             => '2013-04-06',
                                                        'Ceased as Minister on'                                                                => '2016-04-29', }, }
      )
    end
  end
end
