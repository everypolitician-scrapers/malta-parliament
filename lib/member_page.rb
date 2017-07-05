# frozen_string_literal: true

require 'scraped'

class MemberPage < Scraped::HTML
  decorator Scraped::Response::Decorator::CleanUrls

  field :id do
    url.to_s.split('/').last
  end

  field :name do
    name_parts.reject { |part| titles.include? part }.map(&:tidy).join(' ')
  end

  field :honorific_prefix do
    name_parts.select { |part| wanted_titles.include? part }.map(&:tidy).join(';')
  end

  field :faction do
    f = box.xpath('.//strong[contains(.,"Parliamentary Group")]/..//img/@title').text
    return 'Partit Nazzjonalista' if f == 'PN'
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

  def wanted_titles
    %w[Dr]
  end

  def unwanted_titles
    %w[Hon. MP]
  end

  def titles
    wanted_titles + unwanted_titles
  end

  def name_parts
    box.css('h1').text.split(' - ').first.split(' ')
  end

  def box
    noko.css('div.column2')
  end
end
