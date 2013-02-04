class Book < ActiveRecord::Base
  has_many :bookmarks
  belongs_to :user
  attr_accessible :name, :author, :url

  scope :for_user, lambda { |user| 
    { :conditions => {:user_id => user.id}}
  }

  def to_s
    "(#{name}) by (#{author}) @#{url}"
  end

end
