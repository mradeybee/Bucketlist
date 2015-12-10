class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :details, :created_at, :updated_at, :done
end
