module Views
  class Html
    include Singleton
    include HtmlSlice

    # for more component classes
    attr_reader :foods

    def initialize
      @foods = Views::Foods::Html.new
    end

    def hello(t)
      html_slice do
        tag(:p, t.hello.message)
      end
    end
  end
end
