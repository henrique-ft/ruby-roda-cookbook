class App < Roda
  include HtmlSlice

  # PLUGINS
  #plugin :hash_branch_view_subdir
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')

  route(&:hash_branches)
end
