class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :user_id, presence: true

  def self.blists(user)
    Bucketlist.where("user_id = ? OR publicity  = ?", user, true)
  end
end
