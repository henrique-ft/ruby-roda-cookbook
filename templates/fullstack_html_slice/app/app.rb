class App < Roda
  # PLUGINS

  # General plugins
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  #plugin :common_logger
  plugin :halt

  def render(view_class, **params)
    view_class.new.to_html(**params)
  end

  plugin :not_found do
    'not found'
  end

  route(&:hash_branches)
end
