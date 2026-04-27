require_relative 'boot'

use Rack::Static, :urls => ["/public"]

run App
