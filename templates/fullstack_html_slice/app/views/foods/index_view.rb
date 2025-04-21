module Foods
  class IndexView < Layout
    def initialize(foods)
      @foods = foods
    end

    def to_html
      layout {
        ul {
          @foods.each do |food|
            li food.inspect
          end
        }
      }
    end
  end
end
