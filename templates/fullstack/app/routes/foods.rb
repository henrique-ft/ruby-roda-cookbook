class App
  hash_branch('foods') do |r|
    r.is do
      r.get do
        @foods = Food.order(:name).all

        html_layout do
          ul do
            @foods.each do |food|
              li food.inspect
            end
          end
        end
      end
    end
  end
end
