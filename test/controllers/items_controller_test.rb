require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "creates an item" do
    create_bucketlist
    post "/v1/bucketlists/1/items",
         { name: "My first item", details: "first item", done: true }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["item"]["name"], "My first item"
  end

  test "rejects items without name" do
    create_bucketlist
    post "/v1/bucketlists/1/items",
         { name: nil, details: "first item", done: true }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["name"][0], "can't be blank"
  end

  test "rejects items without details" do
    create_bucketlist
    post "/v1/bucketlists/1/items",
         { name: "My first item", details: nil, done: true }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 400, response.status
    assert_equal Mime::JSON, response.content_type
    error = JSON.parse(response.body)
    assert_equal error["details"][0], "can't be blank"
  end

  test "sets item as not done" do
    create_bucketlist
    post "/v1/bucketlists/1/items",
         { name: "My first item", details: "first item", done: false }.to_json,
         "Accept" => Mime::JSON,
         "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["item"]["done"], false
  end

  test "Updates Item" do
    create_item
    patch "/v1/bucketlists/1/items/1",
          { name: "My new item", details: "first item", done: false }.to_json,
          "Accept" => Mime::JSON,
          "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["item"]["name"], "My new item"
  end

  test "Deletes Item" do
    create_item
    delete "/v1/bucketlists/1/items/1", {},
           "Accept" => Mime::JSON,
           "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["Deleted"], "Item has been deleted"
  end

  test "Shows Item" do
    create_item
    get "/v1/bucketlists/1/items/1", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["item"]["name"], "My item"
  end

  test "Shows error message for item s that do not exist" do
    create_item
    get "/v1/bucketlists/1/items/1111", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["not_found!"], "Item with id 1111 does not exist"
  end

  test "Shows all Item" do
    create_item
    get "/v1/bucketlists/1/items/", {},
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    item = JSON.parse(response.body)
    assert_equal item["items"][0]["name"], "My item"
  end
end
