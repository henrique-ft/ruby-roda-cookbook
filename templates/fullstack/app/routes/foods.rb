class App
  #FOODS = Food.order(:name).all
  FOODS = JSON.parse(File.read('foods'))

  hash_branch('foods') do |r|
    r.get 'count' do
      { foods: Food.count }
    end

    r.get 'api' do
      { foods: Food.select(:name, :protein, :calories, :fat, :carbohydrate).map(&:to_hash) }
    end

    r.get 'api-all' do
      { foods: Food.all.map(&:to_hash) }
    end

    r.get 'api-10' do
      { foods: App::FOODS.first(10).map(&:to_hash) }
    end

    r.get 'api-25' do
      { foods: App::FOODS.first(25).map(&:to_hash) }
    end

    r.get 'api-50' do
      { foods: App::FOODS.first(50).map(&:to_hash) }
    end

    r.get 'api-100' do
      { foods: App::FOODS.first(100).map(&:to_hash) }
    end

    r.get 'info' do
      view('foods/info')
    end
  end
end
