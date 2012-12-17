class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :username, :email, :password, :password_confirmation, :dictionary_user_id
  has_many :conversions
  has_many :bookmarks
  belongs_to :dictionary_user, :class_name => 'User'
  
  validates_uniqueness_of :username

  scope :editors, {:conditions => {:is_editor => true}}

  # create user
  # if the operator is a admin the can set is_admin and is_editor 
  # else only can set common attributes
  def full_create(attrs,admin_user = false)
    attrs ||= {}
    
    self.attributes = attrs
    self.username = attrs[:username] if attrs[:username]
    if admin_user
      self.is_admin = attrs[:is_admin]
      self.is_editor = attrs[:is_editor]
    end

    self.save
  end

  def dictionary_for
    if self.is_admin
      self.dictionary_user || self
    elsif self.is_editor
      self
    else
      nil
    end
  end

  # update user
  # if the operator is a admin then can edit anything
  # else only edit common attributes
  def full_save(attrs,admin_user = false)
    attrs ||= {}

    is_admin_p = attrs.delete(:is_admin)
    is_editor_p = attrs.delete(:is_editor)

    self.attributes = attrs
    if admin_user
      self.is_admin = is_admin_p
      self.is_editor = is_editor_p
    end
    
    self.save
  end
  
  
  def self.create_administrators(usernames = nil)
    usernames ||= ["jack","administrator"]
    usernames.each do |username|
      attrs = {
        :username => username,
        :email => "#{username}@email.com",
        :password => "phonetic",
        :password_confirmation => "phonetic",
        :is_admin => true,
        :is_editor => true
      }
      User.transaction do
        unless User.exists?({:username => username})
          user = User.new
          user.full_create(attrs,true)
          puts "#{username} created"
        else
          user = User.find_by_username(username)
          user.full_save(attrs,true)
          puts "#{username} updated"
        end
      end
      
    end
    true
  rescue
    false
  end

end
