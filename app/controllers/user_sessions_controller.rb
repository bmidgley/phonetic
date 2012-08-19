class UserSessionsController < ApplicationController
  def new
    redirect_to root_path if current_user
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session
    flash[:notice] = "Successfully logged out."
    redirect_to login_url
  end
end
