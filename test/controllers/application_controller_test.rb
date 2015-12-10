require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "tells if endpoint does not exit" do
    create_bucketlist
    get "/v1", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 404, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "The end point you requested does not exist."
  end

  test "deactivates Users after logout" do
    logout
    get "/v1/bucketlists", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "You must login first"
  end

  test "checks expired session" do
    @auth_token = EXPIRED_TOKEN
    get "/v1/bucketlists", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "This session has expired, please login again"
  end
end
