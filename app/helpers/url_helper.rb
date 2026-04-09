# Provides helpers for generating validated external script urls

module URLHelper
  def safe_script_src(url, host: nil)
    URLParser.call(url, host: host)&.to_s
  end
end
