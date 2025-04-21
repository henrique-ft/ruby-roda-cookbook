module Foods
  class InfoView < Layout
    def to_html
      layout {
        tag :p, 'hey ho lets fo'
      }
    end
  end
end
