class App
  branch "foo" do |r|
    r.get "api" do
      {foo: 'bar'}
    end

    r.get "bar" do
      view('bar')
    end
  end
end
