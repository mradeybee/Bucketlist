require "rails_helper"
RSpec.describe V1::UsersController, type: :request do
  subject(:users) { User.new }
  let(:name) { users.name = "Adebayo" }
  let(:new_name) { users.name = "Adepoju" }
  let(:email) { users.email = "mradeybee@gmail.com" }
  let(:password) { users.password_digest = "password" }
  let(:user) do
    name
    email
    password
  end
  let(:new_user) do
    new_name
    email
    password
  end

  describe "Users" do
    it "creates users" do
      post "/v1/users"
      user
      expect(response).to be_success
    end
  end
end
