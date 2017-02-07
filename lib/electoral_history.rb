# frozen_string_literal: true
require 'scraped'

class ElectoralHistory < Scraped::HTML
  field :events_by_term do
    term_headings.map { |str| str.delete(':') }
                 .map(&:tidy)
                 .zip(events).to_h
  end

  private

  def events
    noko.text
        .split(Regexp.union(term_headings))
        .map(&:tidy).reject(&:empty?)
        .map { |str| str.delete(':') }
        .map { |str| str.split(/(\d\d\d\d\-\d\d\-\d\d)/).map(&:tidy) }
        .map { |arr| Hash[*arr] }
  end

  def term_headings
    noko.first
        .text
        .scan(/([A-Z][a-z]+(?:st|nd|rd|th)\sParliament\s?:?)/)
        .flatten
        .map(&:tidy)
  end
end
