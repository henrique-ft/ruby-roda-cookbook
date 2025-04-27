require 'byebug' if ENV['RACK_ENV'] == 'development'

require 'html_slice'
require 'sequel'
require 'roda'

require_relative 'init'

use Rack::Static, :urls => ["/public"]

#if ENV['RACK_ENV'] != 'development'
  #use Rack::Auth::Basic, "Restricted Area" do |username, password|
    #[username, password] == ['some_username', 'some_password']
  #end
#end

run App
