# frozen_string_literal: true
require 'scraped'

class MemberPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :id do
    url.to_s.split('/').last
  end

  field :name do
    name_parts.reject { |part| titles.include? part }.map(&:tidy).join(' ')
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
    {}
  end

  private

  def titles
    %w(Dr)
  end

  def name_parts
    box.css('h1').text.split(' - ').first.sub('Hon. ', '').sub(' MP', '').tidy.split(' ')
  end 

  def box
    noko.css('div.column2')
  end
end
