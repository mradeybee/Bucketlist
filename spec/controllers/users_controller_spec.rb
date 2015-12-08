require 'rails_helper'
RSpec.describe V1::UsersController, :type => :controller do
  subject(:user) { User.new(name: name, email: email, password_digest: pass) }
  let(:name){ "Adebayo" }
  let(:email){ "mradeybee@gmail.com" }
  let(:password){ "password" }

  describe "Users" do
  it "creates users" do
    post :create, prefix: "/v1/users"
    { user:
      { name: :name, email: :email, password_digest: password }
    }
    # json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of messages are returned
    # expect(json['messages'].length).to eq(10)
  end
end

end
