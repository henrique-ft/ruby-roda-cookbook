class App
  hash_branch('foods') do |r|
    r.get 'api' do
      { foods: Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber).map(&:to_hash) }
    end

    r.get 'api-all' do
      { foods: Food.all }
    end

    r.get 'info' do
      @foods = Food.first(10)

      view('foods/info')
    end
  end
end
