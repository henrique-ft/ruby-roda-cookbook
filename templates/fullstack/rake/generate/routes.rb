module Generate
  class Routes
    def initialize(branch_name, routes_list)
      @branch_name = branch_name
      @routes_list = routes_list
    end

    def call
      if @branch_name.nil? || @branch_name.empty? || @routes_list.nil? || @routes_list.empty?
        puts "Usage: rake generate:routes[branch_name,route1,route2:method]"
        exit 1
      end

      filename = File.join(ensure_and_get_path("../../app/routes"), "#{@branch_name}.rb")

      route_definitions = @routes_list.map do |route_str|
        method, name = route_str.split(':', 2)
        if name.nil?
          name = method
          method = "get" # Default to GET if no method is specified
        end
        if method === "get" && generate_views?
          generate_views
          "    r.#{method} \"#{name}\" do\n      view('#{name}')\n    end"
        else
          "    r.#{method} \"#{name}\" do\n    end"
        end
      end.join("\n\n")

      content = <<~RUBY
      class App
        branch "#{@branch_name}" do |r|
      #{route_definitions}
        end
      end
      RUBY

      File.write(filename, content)
      puts "Created routes file: #{filename}"

      generate_tests
      generate_views if generate_views?
    end

    def generate_tests
      # Generate test file
      test_filename = File.join(
        ensure_and_get_path("../../spec/app/routes"),
        "#{@branch_name}_spec.rb"
      )

      # Calculate relative path to spec_helper.rb
      nesting_level = @branch_name.count('/')
      relative_spec_helper_path = "../" * (2 + nesting_level) + "spec_helper"

      test_route_definitions = @routes_list.map do |route_str|
        method, name = route_str.split(':', 2)
        if name.nil?
          name = method
          method = "get" # Default to GET if no method is specified
        end

        <<~RUBY
        it "responds to #{method.upcase} /#{@branch_name}/#{name}" do
          #{method} "/#{@branch_name}/#{name}"
          expect(last_response.status).to eq(200)
        end
        RUBY
      end.map { |s| s.each_line.map { |l| "  #{l}" }.join }.join("
                                                                 ")

      test_content = <<~RUBY
      require_relative "#{relative_spec_helper_path}"

      describe "Routes for #{@branch_name}" do
      #{test_route_definitions}
      end
      RUBY

      File.write(test_filename, test_content)
      puts "Created test file: #{test_filename}"
    end

    def generate_views
    end

    def generate_views?
      @generate_views ||= Dir.exist?(File.expand_path("../../app/views", __dir__))
    end

    def ensure_and_get_path(path)
      base_path = File.expand_path(path, __dir__)
      full_path_dir = File.join(base_path, File.dirname(@branch_name))
      FileUtils.mkdir_p(full_path_dir) unless File.directory?(full_path_dir)

      base_path
    end
  end
end
