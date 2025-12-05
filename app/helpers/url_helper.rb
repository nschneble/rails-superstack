module UrlHelper
  def safe_script_src(url, host: nil)
    UrlRules.parse_https_url(url, host: host)&.to_s
  end
end
