class Sample < ActiveRecord::Base
  validates_presence_of :english
  attr_accessible :english, :user_id
  belongs_to :user

  scope :for_user, lambda { |user| 
    { :conditions => {:user_id => user.id}}
  }

  scope :for_session, lambda { |session_id| { :conditions => {:session_id => session_id}}}
  
end
