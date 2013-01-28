class Bookmark < ActiveRecord::Base
  attr_accessible :book, :start

  belongs_to :user
  belongs_to :book

  scope :user, lambda{|user| {:conditions => {:user_id => user.id}} }
  scope :book, lambda{|book| {:conditions => {:book_id => book.id}} }
  scope :farthest, {:order => 'start desc', :limit => 1}
end
