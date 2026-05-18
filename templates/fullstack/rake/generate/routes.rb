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

      write_routes_file
      generate_views if generate_views_enabled?
      generate_tests
    end

    def generate_views
      branch_views_dir = File.join(File.expand_path("../../app/views", __dir__), @branch_name)
      FileUtils.mkdir_p(branch_views_dir)
      @routes_list.each do |route_str|
        method, name = parse_route_string(route_str)
        if method == "get"
          view_filename = File.join(branch_views_dir, "#{name}.erb")
          File.write(view_filename, "")
          puts "Created view file: #{view_filename}"
        end
      end
    end

    def generate_tests
      test_filename = File.join(ensure_and_get_path("../../spec/app/routes"), "#{@branch_name}_spec.rb")
      nesting_level = @branch_name.count('/')
      relative_spec_helper_path = "../" * (2 + nesting_level) + "spec_helper"

      test_route_definitions = @routes_list.map do |route_str|
        method, name = parse_route_string(route_str)
        "  it \"responds to #{method.upcase} /#{@branch_name}/#{name}\" do\n" \
        "    #{method} \"/#{@branch_name}/#{name}\"\n" \
        "    expect(last_response.status).to eq(200)\n" \
        "  end"
      end.join("\n")

      test_content = <<~RUBY
      require_relative "#{relative_spec_helper_path}"

      describe "Routes for #{@branch_name}" do
      #{test_route_definitions}
      end
      RUBY
      File.write(test_filename, test_content)
      puts "Created test file: #{test_filename}"
    end

    private

    def write_routes_file
      filename = File.join(ensure_and_get_path("../../app/routes"), "#{@branch_name}.rb")
      route_definitions = @routes_list.map do |route_str|
        method, name = parse_route_string(route_str)
        view_line = (method == "get" && generate_views_enabled?) ? "\n      view('#{name}')" : ""
        "    r.#{method} \"#{name}\" do#{view_line}\n    end"
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
    end

    def parse_route_string(route_str)
      name, method = route_str.split(':', 2)
      method ||= "get"
      [method, name]
    end

    def generate_views_enabled?
      @generate_views_enabled ||= Dir.exist?(File.expand_path("../../app/views", __dir__))
    end

    def ensure_and_get_path(path)
      base_path = File.expand_path(path, __dir__)
      full_path_dir = File.join(base_path, File.dirname(@branch_name))
      FileUtils.mkdir_p(full_path_dir) unless File.directory?(full_path_dir)

      base_path
    end
  end
end
