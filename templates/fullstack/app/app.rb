class App < Roda
  # PLUGINS

  # General plugins
  plugin :autoload_hash_branches
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :common_logger
  plugin :halt

  # View plugins
  plugin :render, views: 'app/views'
  plugin :partials, views: 'app/views'
  plugin :content_for, append: false

  plugin :not_found do
    'not found'
  end

  autoload_hash_branch_dir('./app/routes')

  route do |r|
    r.hash_branches

    r.get { view('hello') }
  end
end
