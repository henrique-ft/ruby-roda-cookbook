module Views
  module Foods
    class Html
      include HtmlSlice

      def list(foods)
        html_slice do
          foods.each do |food|
            tag(:p, food.name, style: 'color: gray')
          end
        end
      end
    end
  end
end
