module Generate
  class Routes
    def initialize(branch_name, routes_list)
      @branch_name = branch_name
      @routes_list = routes_list
    end

    def generate
      if @branch_name.nil? || @branch_name.empty? || @routes_list.nil? || @routes_list.empty?
        puts "Usage: rake generate:routes[branch_name,route1,route2:method]"
        exit 1
      end

      routes_array = @routes_list.split(',').map(&:strip)

      routes_base_path = File.expand_path("./app/routes", __dir__)

      # Ensure the directory structure exists
      full_path_dir = File.join(routes_base_path, File.dirname(@branch_name))
      FileUtils.mkdir_p(full_path_dir) unless File.directory?(full_path_dir)

      filename = File.join(routes_base_path, "#{@branch_name}.rb")

      route_definitions = routes_array.map do |route_str|
        method, name = route_str.split(':', 2)
        if name.nil?
          name = method
          method = "get" # Default to GET if no method is specified
        end
        "    r.#{method} \"#{name}\" do\n    end"
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

      # Generate test file
      test_base_path = File.expand_path("./spec/app/routes", __dir__)

      # Ensure the directory structure exists for tests
      test_full_path_dir = File.join(test_base_path, File.dirname(@branch_name))
      FileUtils.mkdir_p(test_full_path_dir) unless File.directory?(test_full_path_dir)

      test_filename = File.join(test_base_path, "#{@branch_name}_spec.rb")

      # Calculate relative path to spec_helper.rb
      nesting_level = @branch_name.count('/')
      relative_spec_helper_path = "../" * (2 + nesting_level) + "spec_helper"

      test_route_definitions = routes_array.map do |route_str|
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
  end
end
