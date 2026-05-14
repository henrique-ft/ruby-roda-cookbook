module Views
  class Html
    include HtmlSlice

    # for more component classes
    attr_reader :foods

    def initialize(t)
      @t = t
      @foods = Views::Foods::Html.new
    end

    def hello
      html_slice do
        tag(:p, "#{@t.hello.message} #{@t.foo.bar}")
      end
    end
  end
end
