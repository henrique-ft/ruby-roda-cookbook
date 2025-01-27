class App
  hash_branch('foods') do |r|
    r.is do
      r.get do
        @foods = Food.order(:name).all

        layout do
          ul do
            @foods.each do |food|
              li food.inspect
            end
          end
        end
      end
    end

    r.get 'api' do
      { food: 'apple' }
    end
  end
end
