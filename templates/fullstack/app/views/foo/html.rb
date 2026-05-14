module Views
  module Foo
    class Html
      include HtmlSlice

      def say(message)
        html_slice do
          span(message, style: 'color: gray')
        end
      end
    end
  end
end
