module URLHelper
  def safe_script_src(url, host: nil)
    URLRules.parse_https_url(url, host: host)&.to_s
  end
end
