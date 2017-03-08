# frozen_string_literal: true
require 'scraped'
require_relative './member_page'
require_relative './electoral_history'

class ExMemberPage < MemberPage
  field :electoral_history do
    td = noko.xpath('//td[contains(.,"Electoral History")]/following-sibling::td')
    (fragment td => ElectoralHistory).events_by_term
  end
end
