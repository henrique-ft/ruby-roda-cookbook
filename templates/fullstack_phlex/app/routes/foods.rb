class App
  hash_branch('foods') do |r|
    r.get 'api' do
      x
      { food: 'apple' }
    end

    r.get 'info' do
      'hi'
    end

    r.get do
      Food.order(:name).all
    end
  end
end
