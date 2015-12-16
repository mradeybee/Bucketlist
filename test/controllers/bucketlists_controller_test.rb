require "test_helper"

class BucketlistsControllerTest < ActionDispatch::IntegrationTest
  test "creates a bucketlist" do
    auth_token = login
    post "/v1/bucketlists/",
         { name: "My first list", publicity: true }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlist"]["name"], "My first list"
  end

  test "rejects bucketlists without name" do
    auth_token = login
    post "/v1/bucketlists/",
         { name: nil, publicity: true }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["name"][0], "can't be blank"
  end

  test "Shows users bucketlists and others public bucketlists" do
    auth_token = login
    get "/v1/bucketlists", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    no_list = JSON.parse(response.body)
    assert_equal no_list["Oops!"], "Bucketlist is empty"
  end

  test "Shows bucketlist by id" do
    create_bucketlist
    get "/v1/bucketlists/1", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlist"]["name"], "My first list"
  end

  test "denies search for bucketlist by id not belongin to user" do
    create_bucketlist
    another_bucketlist
    cant_view = "You are not permited to view this bucketlist"
    get "/v1/bucketlists/1", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @new_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["unauthorized"], cant_view
  end

  test "Shows error message if bucketlist id is not found" do
    create_bucketlist
    missing = "Bucketlist with id 100 does not exist"
    get "/v1/bucketlists/100", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["not_found!"], missing
  end

  test "Paginates users bucketlists and others public bucketlists" do
    create_bucketlist
    get "/v1/bucketlists", { page: 2, limit: 2 },
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlists"][0]["id"], 3
    assert_equal bucketlist["bucketlists"][1]["id"], 4
  end

  test "searches users bucketlists and others public bucketlists by name" do
    create_bucketlist
    get "/v1/bucketlists", { q: "My first list" },
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlists"][0]["name"], "My first list"
  end

  test "shows not found result for non exiisting queries" do
    @auth_token = login
    get "/v1/bucketlists", { q: "exist" },
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    not_found = JSON.parse(response.body)
    assert_equal not_found["Oops!"], "Bucketlist named 'exist' not found"
  end

  test "updates bucketlist" do
    create_bucketlist
    patch "/v1/bucketlists/1", { name: "My edited bucketlist" }.to_json,
          "Accept" => Mime::JSON,
          "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 202, response.status
    assert_equal Mime::JSON, response.content_type
    bucketlist = JSON.parse(response.body)
    assert_equal bucketlist["bucketlist"]["name"], "My edited bucketlist"
  end

  test "rejects bad updates for bucketlist" do
    create_bucketlist
    patch "/v1/bucketlists/1", { name: nil }.to_json,
          "Accept" => Mime::JSON,
          "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["name"][0], "can't be blank"
  end

  test "deletes bucketlist" do
    create_bucketlist
    delete "/v1/bucketlists/1", {},
           "Accept" => Mime::JSON,
           "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    done = JSON.parse(response.body)
    assert_equal done["Deleted"], "Bucketlist with its items, has been deleted"
  end
end
