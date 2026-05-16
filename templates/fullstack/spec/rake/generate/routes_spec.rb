require_relative "../../spec_helper"
require_relative "../../../rake/generate/routes"
require "fileutils"

RSpec.describe Generate::Routes do
  let(:branch_name) { "test_branch" }
  let(:routes_list) { ["route1", "route2:post", "route3"] }
  let(:generator) { described_class.new(branch_name, routes_list) }

  # Temporary directory for generated files
  let(:tmp_dir) { File.expand_path("../../../tmp/test_generated_files", __dir__) }
  let(:app_routes_dir) { File.join(tmp_dir, "app/routes") }
  let(:app_views_dir) { File.join(tmp_dir, "app/views") }
  let(:spec_app_routes_dir) { File.join(tmp_dir, "spec/app/routes") }
  let(:mock_rake_generate_dir) { File.join(tmp_dir, "rake/generate") } # Simulate the location of the routes.rb file

  before do
    # Create temporary directories
    FileUtils.mkdir_p(app_routes_dir)
    FileUtils.mkdir_p(app_views_dir)
    FileUtils.mkdir_p(spec_app_routes_dir)
    FileUtils.mkdir_p(mock_rake_generate_dir) # Ensure the mock_dir exists for __dir__ context

    # Stub __dir__ for the generator instance to control File.expand_path behavior
    allow(generator).to receive(:__dir__).and_return(mock_rake_generate_dir)

    # Mock puts for any instance of Generate::Routes
    allow_any_instance_of(described_class).to receive(:puts)
    # Stub exit to raise SystemExit, allowing us to test for it
    allow(Kernel).to receive(:exit) { |status| raise SystemExit.new(status) }
  end

  after do
    # Clean up temporary directories
    FileUtils.rm_rf(tmp_dir)
  end

  describe "#initialize" do
    it "sets the branch_name and routes_list" do
      expect(generator.instance_variable_get(:@branch_name)).to eq(branch_name)
      expect(generator.instance_variable_get(:@routes_list)).to eq(routes_list)
    end
  end

  describe "#parse_route_string" do
    it "parses a simple route name, defaulting to GET" do
      expect(generator.send(:parse_route_string, "home")).to eq(["get", "home"])
    end

    it "parses a route name with a method" do
      expect(generator.send(:parse_route_string, "users:post")).to eq(["post", "users"])
    end

    it "parses a route name with a different method" do
      expect(generator.send(:parse_route_string, "items:put")).to eq(["put", "items"])
    end
  end

  describe "#generate_views_enabled?" do
    context "when app/views directory exists" do
      it "returns true" do
        # The app_views_dir is created in the before block
        expect(generator.send(:generate_views_enabled?)).to be true
      end
    end

    context "when app/views directory does not exist" do
      it "returns false" do
        FileUtils.rm_rf(app_views_dir) # Remove it for this specific test
        expect(generator.send(:generate_views_enabled?)).to be false
      end
    end
  end

  describe "#ensure_and_get_path" do
    let(:target_relative_path) { "../../app/some_dir" }
    let(:expected_abs_path) { File.join(tmp_dir, "app/some_dir") }

    before do
      # Ensure the target directory does not exist initially for this test
      FileUtils.rm_rf(expected_abs_path)
    end

    it "creates the directory if it does not exist" do
      generator.send(:ensure_and_get_path, target_relative_path)
      expect(File.directory?(expected_abs_path)).to be true
    end

    it "returns the correct absolute path" do
      expect(generator.send(:ensure_and_get_path, target_relative_path)).to eq(expected_abs_path)
    end
  end

  describe "#call" do
    context "with valid arguments" do
      before do
        generator.call
      end

      it "creates the routes file" do
        expect(File.exist?(File.join(app_routes_dir, "#{branch_name}.rb"))).to be true
      end

      it "creates view files for GET routes" do
        expect(File.exist?(File.join(app_views_dir, branch_name, "route1.erb"))).to be true
        expect(File.exist?(File.join(app_views_dir, branch_name, "route3.erb"))).to be true
        expect(File.exist?(File.join(app_views_dir, branch_name, "route2.erb"))).to be false # Not a GET route
      end

      it "creates the test file" do
        expect(File.exist?(File.join(spec_app_routes_dir, "#{branch_name}_spec.rb"))).to be true
      end

      it "generates correct routes file content" do
        routes_content = File.read(File.join(app_routes_dir, "#{branch_name}.rb"))
        expect(routes_content).to include("class App")
        expect(routes_content).to include("branch \"#{branch_name}\" do |r|")
        expect(routes_content).to include("r.get \"route1\" do\n      view('route1')\n    end")
        expect(routes_content).to include("r.post \"route2\"") # No view for POST
        expect(routes_content).to include("r.get \"route3\" do\n      view('route3')\n    end")
      end

      it "generates correct test file content" do
        test_content = File.read(File.join(spec_app_routes_dir, "#{branch_name}_spec.rb"))
        expect(test_content).to include("require_relative \"../../spec_helper\"")
        expect(test_content).to include("describe \"Routes for #{branch_name}\" do")
        expect(test_content).to include("it \"responds to GET /#{branch_name}/route1\" do\n    get \"/#{branch_name}/route1\"")
        expect(test_content).to include("it \"responds to POST /#{branch_name}/route2\" do\n    post \"/#{branch_name}/route2\"")
        expect(test_content).to include("it \"responds to GET /#{branch_name}/route3\" do\n    get \"/#{branch_name}/route3\"")
      end
    end

    context "with invalid arguments" do
      it "exits if branch_name is nil" do
        generator = described_class.new(nil, routes_list)
        expect { generator.call }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      end

      it "exits if routes_list is empty" do
        generator = described_class.new(branch_name, [])
        expect { generator.call }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      end
    end

    context "when generate_views_enabled? is false" do
      before do
        # Temporarily remove the app_views_dir to simulate generate_views_enabled? returning false
        FileUtils.rm_rf(app_views_dir)
        generator.call
      end

      it "does not create view files" do
        expect(File.exist?(File.join(app_views_dir, branch_name, "route1.erb"))).to be false
        expect(File.exist?(File.join(app_views_dir, branch_name, "route3.erb"))).to be false
      end

      it "generates routes file content without view calls" do
        routes_content = File.read(File.join(app_routes_dir, "#{branch_name}.rb"))
        expect(routes_content).to include("r.get \"route1\" do\n    end") # No view call
        expect(routes_content).to include("r.get \"route3\" do\n    end") # No view call
      end
    end
  end
end
