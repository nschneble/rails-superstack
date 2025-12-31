GravatarImageTag.configure do |config|
  config.default_image           = :identicon # url, :identicon, :monsterid, :wavatar, or 404
  config.filetype                = nil        # gif, jpg or png (default is png)
  config.include_size_attributes = true
  config.rating                  = "R"        # G, PG, R, or X (default is G)
  config.size                    = "126"       # 1–512 (default is 80)
  config.secure                  = false
end
