# frozen_string_literal: true
require 'scraped'

class ElectoralHistory < Scraped::HTML
  def to_h
    events_by_term
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

  def events_by_term
    term_headings.map { |str| str.delete(':') }
                 .map(&:tidy)
                 .zip(events).to_h
  end

  def term_headings
    noko.first
        .text
        .scan(/([A-Z][a-z]+(?:st|nd|rd|th)\sParliament\s?:?)/)
        .flatten
        .map(&:tidy)
  end
end
