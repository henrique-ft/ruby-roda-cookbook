class App < Roda
  # PLUGINS
  #plugin :hash_branch_view_subdir
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')

  plugin :json

  def render(view_class, **params)
    view_class.new.to_html(**params)
  end

  plugin :not_found do
    'not found'
  end

  route(&:hash_branches)
end
