class App
  hash_branch('foods') do |r|
    r.get 'api' do
      { food: 'apple' }
    end

    r.get 'info' do
      view('foods/info')
    end

    r.get do
      @foods = Food.order(:name).all

      view('foods/index')
    end
  end
end
