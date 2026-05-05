require 'bundler/setup'
Bundler.require

#require 'byebug' if ENV['RACK_ENV'] != 'production'

# Config file loads
loader = Zeitwerk::Loader.new
loader.inflector.inflect("db" => "DB")
loader.push_dir("#{__dir__}/app")
loader.collapse("#{__dir__}/app/models")
loader.collapse("#{__dir__}/app/services")
loader.collapse("#{__dir__}/app/config")
#loader.collapse("#{__dir__}/app/views")

#[
  #'config',
  #'models',
  #'services',
  #'callbacks',
  #'actions'
#].each do |path|
  #loader.push_dir("#{__dir__}/app/#{path}")
#end
loader.setup

Oj.mimic_JSON()

# Init DB Conn
Deps::DB::Conn.boot
