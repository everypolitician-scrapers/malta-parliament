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

  field :start_date do
    date_from(electoral_history_data.values.last['Elected on:'])
  end

  private

  def date_from(date)
    Date.strptime(date, '%d.%m.%y').to_s
  end

  def electoral_history_data
    eh = noko.xpath('//td[contains(.,"Electoral History")]/following-sibling::td')
    terms = eh.first.xpath('descendant::strong').map(&:text).map(&:tidy)
    data = eh.text
             .split(Regexp.union(terms))
             .map(&:tidy).reject(&:empty?)
             .map { |str| str.split(/(\d\d?\.\d\d?\.\d\d?)/).map(&:tidy) }
             .map { |arr| Hash[*arr] }
    terms.zip(data).to_h
  end

  def box
    noko.css('div.column2')
  end
end
