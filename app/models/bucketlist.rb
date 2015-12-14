class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :user_id, presence: true

  def self.lists(user)
    Bucketlist.where("user_id = ? OR publicity  = ?", user, true)
  end

  def self.search(user, query)
    Bucketlist.where("user_id = ? AND name = ?", user, query)
  end

  def self.find_list(id, user_id)
    list = Bucketlist.find_by(id: id)
    if  list.nil? || list.user_id == user_id
      list
    else
      {unauthorized: "You are not permited to view this bucketlist"}
    end
  end
end
