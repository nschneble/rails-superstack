module ProfileHelper
  PROFILE_TABS = %w[email api_tokens].freeze

  def valid_tab?(tab)
    PROFILE_TABS.include? tab.to_s
  end
end
