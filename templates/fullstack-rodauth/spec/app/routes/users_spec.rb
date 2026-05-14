require_relative "../../spec_helper"

describe "Routes for users" do
  it "responds to GET /users/a" do
    get "/users/a"
    expect(last_response.status).to eq(200)
  end

                                                                   it "responds to POST /users/b" do
    post "/users/b"
    expect(last_response.status).to eq(200)
  end

                                                                   it "responds to PUT /users/c" do
    put "/users/c"
    expect(last_response.status).to eq(200)
  end

end
