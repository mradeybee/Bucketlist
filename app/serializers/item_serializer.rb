class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :details, :created_at, :updated_at, :done, :errors

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
