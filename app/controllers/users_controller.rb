class UsersController < ApplicationController
  before_filter :access_for_admin

  def index
    @users = User.find(:all)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new
    if @user.full_create(params[:user],true)
      flash[:notice] = "Create user successful."
      redirect_to users_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.full_save(params[:user],true)
      flash[:notice] = "Successfully updated user."
      redirect_to users_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy if user
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end
  
end
