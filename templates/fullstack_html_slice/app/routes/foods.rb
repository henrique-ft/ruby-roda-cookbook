class App
  hash_branch('foods') do |r|
    r.get 'api' do
      { food: 'apple' }
    end

    r.get 'info' do
      Foods::InfoView.new.to_html
    end

    r.get do
      Foods::IndexView
        .new(Food.order(:name).all)
        .to_html
    end
  end
end
