module Views
  class Html
    include HtmlSlice

    # for more component classes
    attr_reader :foo

    def initialize(t)
      @t = t
      @foo = Views::Foo::Html.new
    end

    def js_include_tag(entrypoint)
      if Config.not_production?
        return "<script src=\"/public/#{entrypoint}.js\" defer></script>"
      end

      "<script src=\"#{Config.get[:assets][:host]}/#{entrypoint}.js\" defer></script>"
    end

    def navbar
      html_slice do
        div class: "navbar" do
          a "home", href: "/"
          a "foo/bar", href: "/foo/bar"
        end
      end
    end
  end
end
