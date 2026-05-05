module Config
  def self.get
    {
      secret: (ENV['SESSION_SECRET'] || 'UAe&&3q8<FQF8HiF)>l0hbPk£vBQ#IrYsoO}14k\l+-/gIU[j}l0hbPk£vBQ#IrY'),
      environment: ENV['RACK_ENV'] || 'development',
      i18n: { translations: ['app/config/i18n'] },
      deps: {
        db: Deps::DB::Conn.get
      }
    }
  end
end
