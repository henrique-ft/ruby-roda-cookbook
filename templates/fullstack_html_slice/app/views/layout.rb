class Layout
  include HtmlSlice

  def layout(&block)
    html_layout do
      tag :head do
      end

      tag :body do
        yield
      end
    end
  end
end
