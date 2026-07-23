# Shim satisfying `require "rack-attack"` (hyphen), which some code paths
# call by mistake instead of the gem's real require path, `require "rack/attack"`.
# See config/initializers/rack_attack.rb for why this exists.
require "rack/attack"
