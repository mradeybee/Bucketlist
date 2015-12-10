class BucketlistSerializer < ActiveModel::Serializer
  attributes :name, :id, :items, :created_at, :updated_at, :created_by,
             :publicity
  has_many :items
  def created_by
    user = User.find(object.user_id)
    user.name
  end
end
