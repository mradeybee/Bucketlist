require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "coveralls"
Coveralls.wear!
module ActionDispatch
  class IntegrationTest
    def create_user
      @user = User.create(name: "Adebayo", email: "adey@bee.com",
                          password: "password")
    end

    def login
      create_user
      post "/v1/auth/login",
           email: "adey@bee.com", password: "password"
      result = JSON.parse(response.body)
      result["token_key"]
    end

    def logout
      @auth_token = login
      get "/v1/auth/logout", {},
           "Accept" => Mime::JSON,
           "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
    end

    def create_bucketlist
      @auth_token = login
      5.times do
        post "/v1/bucketlists/",
             { name: "My first list", publicity: true }.to_json,
             "Accept" => Mime::JSON,
             "Content-Type" => Mime::JSON.to_s,
             "Authorization" => @auth_token
      end
    end

    def create_item
      create_bucketlist
      5.times do
        post "/v1/bucketlists/1/items",
             { name: "My item", details: "first item", done: true }.to_json,
             "Accept" => Mime::JSON,
             "Content-Type" => Mime::JSON.to_s, "Authorization" => @auth_token
      end
    end
  end
end
