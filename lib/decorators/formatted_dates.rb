# frozen_string_literal: true
require 'scraped'

# Turns a date like 1.1.64 into a preferred format: 1964-01-01
class FormattedDates < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.traverse do |node|
        next unless node.text?
        node.text.scan(/(\d\d?\.\d\d?\.\d\d(?:\d\d)?)/).each do |m|
          node.content = node.text.gsub(m.first, formatted_date(m.first))
        end
      end
    end.to_s
  end

  private

  def formatted_date(date)
    Date.strptime(date, '%d.%m.%y').to_s
  end
end
