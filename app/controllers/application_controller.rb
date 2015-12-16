class ApplicationController < ActionController::API
  include ActionController::Serialization

  def no_route_found
    found = { Error: "The end point you requested does not exist.",
              Debug: "Please check the documentation for existing end points" }
    render json: found, status: 404
  end

  def authenticate
    token = request.headers["HTTP_AUTHORIZATION"]
    status, payload = V1::Authenticate.decode_token(token)
    if status
      user = payload
      @current_user = User.where(id: user["id"], email: user["email"]).first
      activate(@current_user)
    else
      render json: payload, status: 401
    end
  end

  def activate(user)
    unless user && user.active?
      render json: { Error: "You must login first" }, status: 401
    end
  end
end
