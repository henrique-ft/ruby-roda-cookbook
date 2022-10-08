# Ruby Roda Cookbook
[Rendering views](#rendering-views)
[Rendering JSON](#rendering-json)

---

### Rendering views

- Create a directory for views named `views` in the root of your project

```
$ mkdir views
```

- Create a layout file inside this directory

```
$ touch views/layout.erb
```

```ruby
<%= yield %>
```

- Create the view file

```
$ touch views/foo/index.erb
```

```html
<h1> Hello </h1>
```

- Add `:render` plugin and `view 'foo/index'`

```ruby
class App < Roda                   
  plugin :render # import render             
                                 
  route do |r|                   
    r.root do                     
      view 'foo/index' # this maps to views/food/index.erb        
    end   
  end
end
```

more info: 

- [https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html](https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html)

### Rendering JSON

```ruby
class App < Roda                   
  plugin :json # import json             

  route do |r|                   
    r.root do                     
      [{
        name: 'Banana',
        nutrients: [
          {
            name: 'B vitamin',
            quantity: 3,
            quantity_unit: 'mg'
          }
        ]
      }] # automatic conversion to json
    end   
  end
end
```

more info: 

- [https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Json.html](https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Json.html)

# Contributing

Help us grow this Roda cookbook, open a PR with your contribution!
