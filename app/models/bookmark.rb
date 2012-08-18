class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  named_scope :user, lambda{|user| {:conditions => {:user_id => user.id}} }
  named_scope :book, lambda{|book| {:conditions => {:book_id => book.id}} }
  named_scope :farthest, {:order => 'start desc', :limit => 1}
end
