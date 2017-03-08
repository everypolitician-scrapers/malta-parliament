# frozen_string_literal: true
require 'scraped'

# Turns a date like 1.1.64 into a preferred format: 1964-01-01
class FormattedDates < Scraped::Response::Decorator
  def body
    super.gsub(/(\d{1,2}\.\d{1,2}\.\d{2,4})/) { |match| Date.strptime(match, '%d.%m.%y').to_s }
  end

  private

  def formatted_date(date)
    Date.strptime(date, '%d.%m.%y').to_s
  end
end
