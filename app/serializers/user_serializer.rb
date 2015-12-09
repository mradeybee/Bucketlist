class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :errors

  has_many :bucketlists

  def attributes
    data = super
    if data[:errors].empty?
      data.delete :errors
    else
      data = { errors: data[:errors].full_messages }
    end
    data
  end
end
