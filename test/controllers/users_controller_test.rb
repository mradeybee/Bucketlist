require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "creates users" do
    post "/v1/users",
    { name: "Adebayo", email: "adey@bee.com",
      password: "password" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    user = JSON.parse(response.body)
    assert_equal user["user"]["name"], "Adebayo"
  end

  test "rejects bad email" do
    post "/v1/users",
    { name: "Adebayo", email: "adeybee.com",
      password: "password" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "User not created"
  end

  test "rejects users without email" do
    post "/v1/users",
    { name: "Adebayo", email: nil,
      password: "password" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "User not created"
  end

  test "rejects users without name" do
    post "/v1/users",
    { name: nil , email: "adey@bee.com",
      password: "password" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "User not created"
  end

  test "rejects users without password" do
    post "/v1/users",
    { name: "Adebayo" , email: "adey@bee.com",
      password: nil }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "User not created"
    assert_equal 400, response.status
  end

  test "rejects users with password less than six characters" do
    post "/v1/users",
    { name: "Adebayo" , email: "adey@bee.com",
      password: "ade" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "User not created"
    assert_equal 400, response.status
  end

  test "Fails to update Update unathorized Users" do
    create_user
    patch "/v1/users/#{@user.id}",
    { name: "Adepoju", email: "adey@bee.com",
      password: "password" }.to_json,
    {"Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }
    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "An error occured, please login again"
    assert_equal 401, response.status
  end

  test "Update Athorized Users" do
    @auth_token = login
    patch "/v1/users/#{@user.id}",
    { name: "Adepoju", email: "adey@bee.com",
      password: "password" }.to_json,
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 202, response.status
  end
end
