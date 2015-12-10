require "test_helper"

class BucketlistsControllerTest < ActionDispatch::IntegrationTest
  test "creates a bucketlist" do
    auth_token = login
    post "/v1/bucketlists/",
    { name: "My first list", publicity: true }.to_json,
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token }
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlist"]["name"], "My first list"
  end

  test "rejects bucketlists without name" do
    auth_token = login
    post "/v1/bucketlists/",
    { name: nil, publicity: true }.to_json,
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token }
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["Error"], "Bucketlist not created"
  end

  test "Shows users bucketlists and others public bucketlists" do
    auth_token = login
    get "/v1/bucketlists",{},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    no_list = JSON.parse(response.body)
    assert_equal no_list["Oops!"], "Bucketlist is empty"
  end

  test "Shows bucketlist by id" do
    create_bucketlist
    get "/v1/bucketlists",{id: 1},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlists"][0]["name"], "My first list"
  end

  test "Paginates users bucketlists and others public bucketlists" do
    create_bucketlist
    get "/v1/bucketlists",{page: 2, limit: 2},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlists"][0]["id"], 3
    assert_equal bucketlist["bucketlists"][1]["id"], 4
  end

  test "searches users bucketlists and others public bucketlists by name" do
    create_bucketlist
    get "/v1/bucketlists",{q: "My first list"},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlists"][0]["name"], "My first list"
  end
  test "shows not found result for non exiisting queries" do
    create_bucketlist
    get "/v1/bucketlists",{q: "My list"},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    not_found = JSON.parse(response.body)
    assert_equal not_found["Oops!"], "Bucketlist named 'My list' not found"
  end

  test "edits bucketlist" do
    create_bucketlist
    patch "/v1/bucketlists/1",{ name: "My edited bucketlist" }.to_json,
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 202, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlist"]["name"], "My edited bucketlist"
  end

  test "deletes bucketlist" do
    create_bucketlist
    delete "/v1/bucketlists/1",{},
    {"Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    done = JSON.parse(response.body)
    assert_equal done["Deleted"], "Bucketlist with its items, has been deleted"
  end
end
