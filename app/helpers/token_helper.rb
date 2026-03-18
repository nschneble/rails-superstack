module TokenHelper
  def format_last_used_at(token)
    timestamp = last_used_at_in_words(token) ||
      t("user_profile.api_tokens.active.never_used")

    t("user_profile.api_tokens.active.last_used_at", timestamp:)
  end

  def last_used_at_in_words(token)
    return if token.blank? || token.last_used_at.blank?

    "#{time_ago_in_words(token.last_used_at)} ago"
  end
end
