class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items
  # before_create :add_user
  validates :name, presence: true
  validates :user_id, presence: true

  def self.all_bucketlists(user)
    Bucketlist.where("user_id = ? OR publicity  = ?", user, true)
  end
end
