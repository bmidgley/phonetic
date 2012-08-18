class Book < ActiveRecord::Base
  has_many :bookmarks
  belongs_to :user

  named_scope :for_user, lambda { |user| 
    { :conditions => {:user_id => user.id}}
  }

end
