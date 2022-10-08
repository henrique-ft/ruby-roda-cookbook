![](http://roda.jeremyevans.net/images/roda-logo.svg)

# 📖 Ruby Roda Cookbook

<div class="nav">
  <ul>
    <li><a href="#routing">Routing</a></li>
    <li><a href="#rendering-views">Rendering views</a></li>
    <li><a href="#returning-json">Returning JSON</a></li>
    <li><a href="#returning-specific-status-code">Returning specific status code</a></li>
    <li><a href="#cors">CORS</a></li>
    <li><a href="#auto-reload">Auto reload</a></li>
    <li><a href="#accessing-through-many-devices">Accessing through many devices</a></li>
    <li><a href="#csrf">CSRF</a></li>
    <li><a href="#cross-site-scripting">Cross Site Scripting (XSS)</a></li>
    <li><a href="#creating-roda-plugins">Creating Roda plugins</a></li>
  </ul>
</div>

---

### Routing

Roda suport `get` and `post` verbs initially

```ruby
class App < Roda    
  route do |r|   
    r.get do              # GET
      r.on "a" do         # GET /a branch
        r.on "b" do       # GET /a/b branch
          r.is "c" do end # GET /a/b/c request
          r.is "d" do end # GET /a/b/d request
        end
      end
    end

    r.post do             # POST
      r.on "a" do         # POST /a branch
        r.on "b" do       # POST /a/b branch
          r.is "c" do end # POST /a/b/c request
          r.is "e" do end # POST /a/b/e request
        end
      end
    end
  end
end
```

For `delete`, `put` and `patch`, we must use `all_verbs`plugin

```ruby
class App < Roda  
  plugin :all_verbs
  
  route do |r|   
    route do |r|
      r.delete do
        # Handle DELETE
      end
      r.put do
        # Handle PUT
      end
      r.patch do
        # Handle PATCH
      end
    end
  end
end
```

Getting values from url

```ruby
class App < Roda  
  # GET /post/2011/02/16/hello
  r.get "post", Integer, Integer, Integer, String do |year, month, day, slug|
    "#{year}-#{month}-#{day} #{slug}" #=> "2011-02-16 hello"
  end
end
```

More info
- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-The+Routing+Tree" target="_blank">"The Routing Tree" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Matchers" target="_blank">"Matchers" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/AllVerbs.html" target="_blank">(all_verbs plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/AllVerbs.html</a>

### Rendering views

Create a directory for views named `views` in the root of your project

```
$ mkdir views
```

Create a layout file inside this directory

```
$ touch views/layout.erb
```

```ruby
<%= yield %>
```

Create the view file

```
$ touch views/foo/index.erb
```

```html
<h1> Hello </h1>
```

Add `:render` plugin and `view 'foo/index'`

```ruby
class App < Roda                   
  plugin :render # import render             
                                 
  route do |r|                   
    r.root do                     
      view 'foo/index' # this maps to views/food/index.erb  with layout       
    end   

    r.get 'without-layout' do                     
      render 'foo/index' # this maps to views/food/index.erb without layout       
    end   
  end
end
```

More info: 

- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Rendering" target="_blank">'Rendering' section on Roda README.md</a>
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html" target="_blank">(render plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html</a>

### Returning JSON

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

More info: 

- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Json.html" target="_blank">(json plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Json.html</a>

### Returning specific status code

```ruby
class App < Roda                       
  route do |r|                   
    r.root do                     
      response.status = 201 # Set status in global response object

      "" # return something                  
    end   
  end
end
```

More info:

- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Status+Codes" target="_blank">"Status Codes" section on Roda README</a>

### Halting requests

```ruby
class App < Roda
  plugin :halt # load the halt plugin
                       
  route do |r|                   
    r.root do                     
      r.halt(403)              
    end   

    r.get "example2" do
      r.halt('body')
    end

    r.get "example3" do
      r.halt(403, 'body')
    end

    r.get "example4" do
      r.halt(403, {'Content-Type'=>'text/csv'}, 'body')
    end

    r.get "example5" do
      r.halt([403, {'Content-Type'=>'text/csv'}, ['body']])
    end
  end
end
```

More info:
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Halt.html" target="_blank">(halt plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Halt.html</a>

### CORS

Use `rack-cors` gem:

```ruby
gem 'rack-cors' # Gemfile
```

in `config.ru`:

```ruby
require "rack/cors"

require_relative "app" # require roda app

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end

run app.freeze.app
```

More info:

- <a href="https://github.com/cyu/rack-cors" target="_blank">(rack-cors) https://github.com/cyu/rack-cors</a>

### Auto reload

Use `rerun` gem:

```
$ gem install rerun
```

and then:

```
$ rerun 'rackup'
```

More info:

- <a href="https://github.com/alexch/rerun" target="_blank">(rerun) https://github.com/alexch/rerun</a>
- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Code+Reloading" target="_blank">"Code Reloading" section on Roda README</a>

### Accessing through many devices

Run Roda with this command

```
rackup --host 0.0.0.0 --port 9292
```

and then, access your IP address in port `9292`

### CSRF

 <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Cross+Site+Request+Forgery+-28CSRF-29" target="_blank">"CSRF" section on Roda README</a>

### Cross Site Scripting

 <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Cross+Site+Scripting+-28XSS-29" target="_blank">"Cross Site Scripting (XSS)" section on Roda README</a>

### Creating Roda plugins

- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-How+to+create+plugins" target="_blank">"How to create plugins" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Registering+plugins" target="_blank">"Registering plugins" section on Roda README</a>

# Contributing

Help us grow this Roda cookbook, open a PR with your contribution!
