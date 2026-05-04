require 'async'

class App
  FOODS = Food.order(:name).all
  #FOODS = JSON.parse(File.read('foods'))
  MAP = {
    [5,1] => {}, [5,2] => {}, [5,3] => {}, [5,4] => {}, [5,5] => {},
    [4,1] => {}, [4,2] => {}, [4,3] => {}, [4,4] => {}, [4,5] => {},
    [3,1] => {}, [3,2] => {}, [3,3] => {}, [3,4] => {}, [3,5] => {},
    [2,1] => {}, [2,2] => {}, [2,3] => {}, [2,4] => {}, [2,5] => {},
    [1,1] => {}, [1,2] => {}, [1,3] => {}, [1,4] => {}, [1,5] => {},
  }

  hash_branch('foods') do |r|
    r.get 'average-request' do
      x = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber)
      y = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber)
      @foods = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber).map(&:to_hash)
      i = 0
      while i <= 10 do
        if i > 0 && i < 20
          @foods[i][:fat] = rand(1..5)
          @foods[i][:protein] = rand(1..5)
          @foods[i][:fiber] = rand(1..5)
        end

        i += 1
      end

      view('foods/info')
    end

    r.get 'average-request-inertia' do
      x = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber)
      y = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber)
      @foods = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber).map(&:to_hash)

      i = 0
      while i <= 10 do
        if i > 0 && i < 20
          @foods[i][:fat] = rand(1..5)
          @foods[i][:protein] = rand(1..5)
          @foods[i][:fiber] = rand(1..5)
        end

        i += 1
      end

      view('foods/info_2')
    end

    r.get 'api-cpu' do
      foods = db[:foods].select(:name, :protein, :calories, :fat, :carbohydrate).first

      ticks = []
      n = 0
      while n <= 10 do
        i = 0.0
        while i <= 90 do
          tick = { time: i, goal: false }
          tick[:ball_position] = [rand(1..5), rand(1..5)]
          MAP[[:ball_position]]
          if rand > 0.2 && rand < 0.8 && rand && rand
            tick[:goal] = true
          end
          tick[:name1] = foods[:name]
          tick[:description_code] = foods[:fat]
          tick[:name2] = foods[:name]
          i = i+1
          ticks.push(tick)
        end
        n = n+1
      end

      #{ ticks: [] }
      { ticks: }
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
      @foods = App::FOODS
      view('foods/info')
    end
  end
end
