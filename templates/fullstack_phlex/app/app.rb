class App < Roda
  # Routing
  #plugin :hash_branch_view_subdir
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')
  plugin :all_verbs
  plugin :not_found
  # Rendering
  plugin :partials, views: 'app/views'
  plugin :content_for, append: false
  plugin :halt
  plugin :json
  plugin :exception_page
  plugin :error_handler do |e|
    next exception_page(e, css_file: '/public/exception_page.css') if ENV['RACK_ENV'] == 'development'
  end
  # Request / Response
  plugin :caching
  plugin :cookies
  plugin :content_security_policy do |csp|
    #csp.default_src :none
    #csp.img_src :self
    #csp.style_src :self
    #csp.script_src :self
    #csp.font_src :self
    #csp.form_action :self
    #csp.base_uri :none
    #csp.frame_ancestors :none
    #csp.block_all_mixed_content
  end
  # CSRF Protection
  plugin :route_csrf
  # Other
  plugin :common_logger
  plugin :flash
  plugin :json_parser
  plugin :sessions, secret: (ENV['SESSION_SECRET'] || 'UAe&&3q8<FQF8HiF)>l0hbPk£vBQ#IrYsoO}14k\l+-/gIU[j}l0hbPk£vBQ#IrY')
  plugin :i18n

  not_found do
    'not found'
  end

  route do |r|
    r.hash_branches

    r.root do
      t.hello.message
    end
  end
end
