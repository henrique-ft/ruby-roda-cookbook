class App
  branch "foods" do |r|
    r.get "api" do
      {foods: Food.all}
    end

    r.get "info" do
      @foods = Food.select(:name, :protein, :calories, :fat, :carbohydrate, :fiber)

      view('info')
    end
  end
end
