# frozen_string_literal: true
require 'scraped'

class MemberPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :id do
    url.to_s.split('/').last
  end

  field :name do
    box.css('h1').text.split(' - ').first.sub('Hon. ', '').sub(' MP', '').tidy
  end

  field :faction do
    f = box.xpath('.//strong[contains(.,"Parliamentary Group")]/..//img/@title').text
    return 'Partit Nazzjonlista' if f == 'PN'
    f
  end

  field :email do
    box.css('a[href*="mailto:"]/@href').text.split('mailto:').drop(1).first
  end

  field :image do
    box.css('img/@src').first.text
  end

  field :source do
    url.to_s
  end

  field :electoral_history do
    data = electoral_history_section.text
                                    .split(Regexp.union(term_headings))
                                    .map(&:tidy).reject(&:empty?)
                                    .map { |str| str.delete(':') }
                                    .map { |str| str.split(/(\d\d?\.\d\d?\.\d\d(?:\d\d)?)/).map(&:tidy) }
                                    .map { |arr| Hash[*arr] }
    term_headings.map { |str| str.delete(':') }
                 .map(&:tidy)
                 .zip(data).to_h
  end

  private

  def electoral_history_section
    noko.xpath('//td[contains(.,"Electoral History")]/following-sibling::td')
  end

  def term_headings
    electoral_history_section.first
                             .text
                             .scan(/([A-Z][a-z]+(?:st|nd|rd|th)\sParliament\s?:?)/)
                             .flatten
                             .map(&:tidy)
  end

  def box
    noko.css('div.column2')
  end
end
