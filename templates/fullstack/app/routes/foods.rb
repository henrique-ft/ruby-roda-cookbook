require 'async'

class App
  #FOODS = Food.order(:name).all
  FOODS = JSON.parse(File.read('foods'))
  MAP = {
    [5,1] => {}, [5,2] => {}, [5,3] => {}, [5,4] => {}, [5,5] => {},
    [4,1] => {}, [4,2] => {}, [4,3] => {}, [4,4] => {}, [4,5] => {},
    [3,1] => {}, [3,2] => {}, [3,3] => {}, [3,4] => {}, [3,5] => {},
    [2,1] => {}, [2,2] => {}, [2,3] => {}, [2,4] => {}, [2,5] => {},
    [1,1] => {}, [1,2] => {}, [1,3] => {}, [1,4] => {}, [1,5] => {},
  }

  hash_branch('foods') do |r|
    r.get 'api-cpu' do
      foods = db[:foods].select(:name, :protein, :calories, :fat, :carbohydrate)

      ticks = []
      #(1..2).each do
        i = 0.0
        while i <= 90 do
          tick = {time: i, goal: false}
          tick[:ball_position] = [rand(1..5), rand(1..5)]
          MAP[[:ball_position]]
          if rand > 0.2 && rand < 0.8 && rand && rand
            tick[:goal] = true
          end
          i = i+0.5
          ticks.push(tick)
        end
        #ticks = []
      #end
      { ticks: ticks }
    end

    r.get 'count' do
      { foods: Food.count }
    end

    r.get 'api-conn' do
      foods = nil
      #Sequel.connect("sqlite://db/#{ENV['RACK_ENV'] || 'development'}.db") do |db|
        #if Sequel::Migrator.is_current?(db, 'db/migrations')
          #foods = db[:foods].select(:name, :protein, :calories, :fat, :carbohydrate)
        #end
        foods = db[:foods].select(:name, :protein, :calories, :fat, :carbohydrate)
      #end

      { foods: }
    end

    r.get 'api' do
      { foods: Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber).map(&:to_hash) }
    end

    r.get 'api-all' do
      #{ foods: Food.all.map(&:to_hash) }
      { foods: Food.all }
      #{ foods: db[:foods].all }
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
