class App
  FOODS = Food.order(:name).all

  hash_branch('foods') do |r|
    r.get 'api' do
      { foods: [] }
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

    r.get do
      Food.order(:name).all.map(&:to_hash)
    end
  end
end
