class SamplesController < ApplicationController
  
  def new
    @sample = Sample.new
  end
  
  def create
    @sample = Sample.new(params[:sample])
    if current_user
      @sample.user = current_user.dictionary_for
    else
      @sample.session_id = session[:session_id]
    end
    if @sample.save
      flash[:notice] = "Successfully created sample."
      redirect_to :action => :show, :id => @sample.id
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sample = Sample.find(params[:id])
  end
  
  def update
    @sample = Sample.find(params[:id])
    if @sample.user == current_user || current_user.is_admin
      if @sample.update_attributes(params[:sample])
        flash[:notice] = "Successfully updated sample."
        redirect_to :action => :show, :id => @sample.id
      else
        flash[:notice] = "Update failed"
        render :action => 'edit'
      end
    else
      flash[:notice] = "Access denied"
    end
  end
  
  def destroy
    @sample = Sample.find(params[:id])
    session[:current] = true
    if current_user
      if @sample.user == current_user || current_user.is_admin
        @sample.destroy
        flash[:notice] = "Successfully destroyed sample."
      else
        flash[:notice] = "Access denied"
      end
    elsif @sample.session_id == session[:session_id]
      @sample.destroy
      flash[:notice] = "Successfully destroyed sample."
    end
    redirect_to samples_url
  end

  def show
    sample = Sample.find(params[:id])
    session[:current] = true
    if current_user
      @sample = sample
    elsif sample.session_id == session[:session_id]
      @sample = sample
    end
    @translation = Conversion.convert(@sample.english, (current_user.id rescue nil))
    @split_sample = @sample.english.split(" ")
    @split_translation = @translation.split(" ")
    @line_length = 80
  end
  
  def index
    if current_user
      @samples = Sample.for_user(current_user.dictionary_user || current_user)
    else
      session[:current] = true
      @samples = Sample.for_session(session[:session_id])
    end
  end
end
