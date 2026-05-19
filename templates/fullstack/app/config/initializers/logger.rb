module Initializers
  module Logger
    def self.init
      @logger = ::Logger.new(STDOUT)
    end

    def self.get = @logger
  end
end
