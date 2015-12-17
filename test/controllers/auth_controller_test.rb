require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "login user" do
    create_user
    post "/v1/auth/login",
         email: "adey@bee.com", password: "password"
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end

  test "reject invalid email" do
    create_user
    post "/v1/auth/login",
         email: "adeybee.com", password: "password"
    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "Invalid Credentials"
  end

  test "reject invalid password" do
    create_user
    post "/v1/auth/login",
         email: "adey@bee.com", password: "sword"
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "Invalid Credentials"
  end

  test "logout user" do
    @auth_token = login
    get "/v1/auth/logout", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    status = JSON.parse(response.body)
    assert_equal status["Status"], "Logged out"
  end
end
