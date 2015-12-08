class BucketlistSerializer < ActiveModel::Serializer
  attributes :name, :id, :items, :created_at, :updated_at, :created_by, :errors,
             :publicity
  has_many :items
  def created_by
    user = User.find(object.user_id)
    user.name
  end

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
