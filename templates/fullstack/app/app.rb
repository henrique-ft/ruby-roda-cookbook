class App < Roda
  include HtmlSlice

  # PLUGINS
  #plugin :hash_branch_view_subdir
  plugin :autoload_hash_branches
  autoload_hash_branch_dir('./app/routes')

  plugin :json

  plugin :not_found do
    layout do
      h1 'not found'
    end
  end

  def layout
    html_layout do
      yield
    end
  end

  route(&:hash_branches)
end
