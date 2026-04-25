class App
  hash_branch('foods') do |r|
    r.get 'api' do
      { food: 'apple' }
    end

    r.get 'info' do
      ::Views::Foods.info
    end

    r.get do
      Food.order(:name).all
    end
  end
end
