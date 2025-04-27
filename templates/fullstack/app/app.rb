class App < Roda
  # PLUGINS
  #plugin :hash_branch_view_subdir
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')

  plugin :json
  plugin :render, views: 'app/views'

  plugin :not_found do
    'not found'
  end

  route do |r|
    r.hash_branches

    r.get { view('hello') }
  end
end
