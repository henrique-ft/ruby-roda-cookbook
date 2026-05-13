require_relative "boot"

if Config.not_production?
  require "rack-livereload"
  require "guard/livereload"
  use Rack::LiveReload
end

use Rack::Static, urls: ["/public"]

run App
