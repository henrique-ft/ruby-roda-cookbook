# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require_relative "../boot"
require "rack/test"
require "rspec"

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.around(:suite) do |&block|
    DB.transaction(rollback: :always) { block.call }
  end

  config.around(:each) do |example|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true) { example.run }
  end
end

def app
  App.freeze.app
end

def log
  LOGGER.level = Logger::INFO
  yield
ensure
  LOGGER.level = Logger::FATAL
end

