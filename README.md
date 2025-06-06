![](http://roda.jeremyevans.net/images/roda-logo.svg)

# 📖 Ruby Roda Cookbook

<div class="nav">
  <ul>
    <li><a href="#routing">Routing</a></li>
    <li><a href="#rendering-views">Rendering views</a></li>
    <li><a href="#serving-static-content">Serving static content</a></li>
    <li><a href="#compiling-assets">Compiling assets</a></li>
    <li><a href="#returning-json">Returning JSON</a></li>
    <li><a href="#returning-specific-status-code">Returning specific status code</a></li>
    <li><a href="#halting-requests">Halting requests</a></li>
    <li><a href="#cors">CORS</a></li>
    <li><a href="#auto-reload">Auto reload</a></li>
    <li><a href="#accessing-through-many-devices">Accessing through many devices</a></li>
    <li><a href="#csrf">CSRF</a></li>
    <li><a href="#cross-site-scripting">Cross Site Scripting (XSS)</a></li>
    <li><a href="#creating-roda-plugins">Creating Roda plugins</a></li>
    <li><a href="#using-multiple-route-files">Using multiple route files</a></li>
    <li><a href="#file-uploads">File uploads</a></li>
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

More info:

- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-The+Routing+Tree" target="_blank">"The Routing Tree" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Matchers" target="_blank">"Matchers" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/AllVerbs.html" target="_blank">(all_verbs plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/AllVerbs.html</a>
- <a href="https://fiachetti.gitlab.io/mastering-roda/#basic-routing" target="_blank">"Basic routing" from "Mastering Roda" book</a>
- <a href="https://fiachetti.gitlab.io/mastering-roda/#match-methods" target="_blank">"Match methods" from "Mastering Roda" book</a>

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

```ruby
<h1> Hello, <%= @name %> </h1>
Age: <%= age %>
```

Add `:render` plugin and `view 'foo/index'`

```ruby
class App < Roda                   
  plugin :render # import render             
                                 
  route do |r|
    @name = 'Henrique' # will be available in the erb file
                   
    r.root do                     
      view 'foo/index', locals: { age: 26 } # this maps to views/food/index.erb  with layout       
    end   

    r.get 'without-layout' do                     
      render 'foo/index', locals: { age: 26 } # this maps to views/food/index.erb without layout       
    end   
  end
end
```

More info: 

- <a href="https://roda.jeremyevans.net/rdoc/files/README_rdoc.html#label-Rendering" target="_blank">'Rendering' section on Roda README.md</a>
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html" target="_blank">(render plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Render.html</a>
- <a href="https://fiachetti.gitlab.io/mastering-roda/#layouts" target="_blank">"Layouts" from "Mastering Roda" book</a> 
- <a href="https://fiachetti.gitlab.io/mastering-roda/#render" target="_blank">"Render" from "Mastering Roda" book</a> 

### Serving static content

```ruby
class App < Roda
  plugin :public # Will serve any file / folder in <your_app_root>/public

  route do |r|
    r.public
  end
end
```

More info:

- <a href="https://fiachetti.gitlab.io/mastering-roda/#public" target="_blank">"Rendering - Public" from "Mastering Roda" book</a> 

### Compiling assets

```ruby
class App < Roda
  # some_file.scss is the scss root, the same for some_file.js for javascript
  # it will find assets/css/some_file.scss and assets/js/some_file.js
  plugin :assets, css: 'some_file.scss', js: 'some_file.js' # Add this plugin

  route do |r|
    r.assets # Add this call

    r.get { |r| view 'index' }
  end
end
```

Create the layout file:

`$ mkdir views && touch views/layout.erb`

```ruby
<html>                 
  <head>               
    # The link to files
    <%= assets(:css) %>
    <%= assets(:js) %> 
  </head>              
                       
  <body>               
    <%= yield %>       
  </body>              
</html>                
```

Create the view file:

`$ touch views/index.erb`

```ruby
<h1> Hello </h1>
```

Create some scss files:

`$ mkdir assets/css && touch assets/css/some_file.scss`

```css
@import 'global.scss';
```

`$ touch assets/css/_global.scss`

```css
body {                    
  background-color: blue;
}                         
```

Create the js file:

`$ mkdir assets/js && touch assets/js/some_file.js`

```javascript
console.log("hello")
```

More info: 

- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Assets.html" target="_blank">(assets plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Assets.html</a>

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

run App.freeze.app
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

### Using multiple route files

#### Option 1 (best way)

`routes/foo.rb`

```ruby
class App                  
  hash_branch('foo') do |r|
    r.is do                
      r.get do             
        'hello'            
      end                  
    end                    
  end                      
end                        
```

`config.ru`

```ruby
require 'roda'                        
                                      
class App < Roda                      
  # PLUGINS                           
  #plugin :hash_branch_view_subdir    
  plugin :autoload_hash_branches      
  autoload_hash_branch_dir('./routes')
                                      
  route(&:hash_branches)              
end                                   
                                      
run App.freeze.app                    
```

#### Option 2

`routes/foo.rb`

```ruby
module Routes
  class Foo < Roda
    route do |r|
      r.get do
        "hello foo"
      end
    end
  end
end
```

`routes/bar.rb`

```ruby
module Routes
  class Bar < Roda
    route do |r|
      r.get do
        "hello bar"
      end
    end
  end
end
```
`config.ru`

```ruby
require "roda"

Dir['routes/*.rb'].each { |f| require_relative f }

class App < Roda
  plugin :multi_run # Allow to group many "r.run" in one call

  run 'foo', Routes::Foo
  run 'bar', Routes::Bar

  # Same as
  # route do |r| 
  #   r.multi_run
  # end
  route(&:multi_run)
end

run App.freeze.app
```

#### Option 3

`routes/foo.rb`

```ruby
module Routes
  module Foo
    def self.included(app)   
      app.class_eval do      
        route('foo') do |r|
          r.get do
            "hello foo, #{@shared_value}"
          end
        end
      end
    end
  end
end
```

`routes/bar.rb`

```ruby
module Routes
  module Bar
    def self.included(app)   
      app.class_eval do      
        route('bar') do |r|
          r.get do
            "hello bar, #{@shared_value}"
          end
        end
      end
    end
  end
end
```
`config.ru`

```ruby
require "roda"

Dir['routes/*.rb'].each { |f| require_relative f }

class App < Roda
  plugin :multi_route

  include Routes::Foo
  include Routes::Bar

  # route(&:multi_route) 
  route do |r| 
     # with this option, keep in mind that all routes will share the same class scope even in separated files
     # functions defined outside the 'route' block in routes modules may be dangerous
     @shared_value = 'keep focus'
     r.multi_route
  end
end

run App.freeze.app
```

More info:

- <a href="https://roda.jeremyevans.net/rdoc/files/doc/conventions_rdoc.html" target="_blank"> "Conventions" section on Roda doc </a>
- <a href="https://github.com/jeremyevans/roda#label-Composition" target="_blank"> "Composition" section on Roda README</a>
- <a href="https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/MultiRoute.html" target="_blank">(multi_route plugin) https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/MultiRoute.html</a>

### File uploads

Install and use Shrine (<a href="https://shrinerb.com/" target="_blank">https://shrinerb.com/</a>)

# Contributing

Help us grow this Roda cookbook, open a PR with your contribution!
