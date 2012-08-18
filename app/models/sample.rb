class Sample < ActiveRecord::Base
  validates_presence_of :english
  attr_accessible :english, :user_id
  belongs_to :user

  named_scope :for_user, lambda { |user| 
    { :conditions => {:user_id => user.id}}
  }

  named_scope :for_session, lambda { |session_id| { :conditions => {:session_id => session_id}}}
  
end
