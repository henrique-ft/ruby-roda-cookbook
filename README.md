# Ruby Roda Cookbook
[Rendering views](#rendering-views)

#### Rendering views

- Create a directory for views named `views` in the root of your project

```
mkdir views
```

- Create a layout file inside this directory

```
touch views/layout.erb
```

```ruby
<%= yield %>
```

- Create the view file

```
touch views/foo/index
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

# Contributing

Help us grow this Roda cookbook, open a PR with your contribution!
