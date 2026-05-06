module Shared
  class Html
    include HtmlSlice

    def hello
      html_slice do
        tag(:p, 'hello')
      end
    end

    def foods_list(foods)
      html_slice do
        foods.each do |food|
          tag(:p, food.name)
        end
      end
    end
  end
end
