# Formats API token display values, including last-used-at timestamps

class ApiTokenDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  delegate_all

  def format_last_used_at
    timestamp = last_used_at_in_words || t("settings.api_tokens.active.never_used")
    t("settings.api_tokens.active.last_used_at", timestamp:)
  end

  def last_used_at_in_words
    return if object.last_used_at.blank?

    "#{time_ago_in_words(object.last_used_at)} ago"
  end
end
