# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  helper_method :current_user, :is_admin, :is_editor

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def is_admin
    current_user && current_user.is_admin?
  end
  
  def is_editor
    current_user && current_user.is_editor?
  end
  
  
  def protect_this
    if current_user.nil?
      flash[:warning] = "Sign in for full access"
      redirect_to login_url
    end
  end
  
  def access_for_admin
    unless is_admin
      flash[:warning] = "Access only for administrators"
      redirect_to login_url
    end
  end
  
  def access_for_editor
    unless is_editor
      flash[:warning] = "Access only for editors"
      redirect_to login_url
    end
  end
  
  private :current_user_session, :current_user
  protected :protect_this, :access_for_editor, :access_for_admin
end
