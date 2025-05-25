module DB
  class Conn
    def self.init
      #@conn = Sequel.connect("sqlite://db/#{ENV['RACK_ENV'] || 'development'}.db")
      @conn =
        Sequel.postgres(
          database: 'app_development',
          host: 'localhost',
          user: 'dev',
          password: 'dev'
        )

      Sequel::Model.plugin :timestamps, update_on_create: true
    end

    def self.get
      @conn
    end
  end
end
