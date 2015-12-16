class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :user_id, presence: true

  def self.all_bucketlists(user)
    Bucketlist.where("user_id = ? OR publicity  = ?", user, true)
  end

  def self.search(user, query)
    Bucketlist.where("user_id = ? OR publicity = ? AND name LIKE ?", user, true, query )
  end

  def self.find_list(id, user_id)
    list = Bucketlist.find_by(id: id)
    if  list.nil? || list.user_id == user_id
      list
    else
      {unauthorized: "You are not permited to view this bucketlist"}
    end
  end

  def self.paginate(type, user, query = nil, page = nil, limit = nil)
    records_to_skip = limit.to_i * (page.to_i - 1)
    if type == "search"
      result = search(user, query).limit(limit).offset(records_to_skip)
    elsif type == "index"
      result = all_bucketlists(user).limit(limit).offset(records_to_skip)
    end
    check_resut(result, type, query)
  end

  def self.check_resut(result, type, query)
    if type == "search" && result.empty?
      return { Oops!: "Bucketlist named '#{query}' not found" }
    elsif type == "index" && result.empty?
      return { Oops!: "Bucketlist is empty" }
    else
      result
    end
  end
end
