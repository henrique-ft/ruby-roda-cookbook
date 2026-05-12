module Initializers
  module Mailer
    def self.init
      ::Mail.defaults do
        if Config.not_production?
          delivery_method :logger
        end
      end
    end
  end
end
