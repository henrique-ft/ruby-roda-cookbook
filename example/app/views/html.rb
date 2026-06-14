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
      @js_include_tag ||=
        if Config.not_production?
          "<script src=\"/public/assets/#{entrypoint}.js\" defer></script>"
        else
          "<script src=\"#{Config.get[:assets][:host]}/#{Config.get[:assets][:manifest]["#{entrypoint}.js"]}\" defer></script>"
        end
    end

    def css_include_tag(entrypoint)
      @css_include_tag ||=
        if Config.not_production?
          "<link rel=\"stylesheet\" href=\"/public/#{entrypoint}.css\" />"
        else
          "<link rel=\"stylesheet\" href=\"#{Config.get[:assets][:host]}/#{Config.get[:assets][:manifest]["#{entrypoint}.css"]}\" />"
        end
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
