class UserSettingsController < ApplicationController
  before_filter :protect_this, :only => [:edit, :update]
  
  
  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end
  
  def create
    @user = User.new
  
    if @user.full_create(params[:user],false)
#      user_session = UserSession.new(params[:user])
#      user_session.save
      flash[:notice] = "Register successful."
      redirect_to my_info_url
    else
      flash[:notice] = "Error saving account. Password must be 4+ characters and account must be unique."
      render :action => 'new'
    end
  end
  
  def update
    @user = current_user
    
    if @user.full_save(params[:user],true)
      flash[:notice] = "Informations updated."
      redirect_to my_info_url
    else
      render :action => 'edit'
    end
  end
  
  

end
