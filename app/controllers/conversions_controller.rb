class ConversionsController < ApplicationController
  
  
  def new
    @conversion = Conversion.new
  end
  
  def create
    @conversion = Conversion.new(params[:conversion])
    @conversion.user = current_user.dictionary_for
    if current_user && @conversion.user && @conversion.save
      flash[:notice] = "Successfully created #{@conversion.english} in #{@conversion.user}'s dictionary."
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @conversion = Conversion.find(params[:id])
  end
  
  def update
    @conversion = Conversion.find(params[:id])
    if current_user && (current_user.is_admin || @conversion.user == current_user) && @conversion.update_attributes(params[:conversion])
      flash[:notice] = "Successfully updated entry."
      redirect_to conversions_url
    else
      flash[:notice] = "Not updated."
      render :action => 'edit'
    end
  end
  
  def destroy
    @conversion = Conversion.find(params[:id])
    if (current_user.is_admin || @conversion.user == current_user) && @conversion.destroy
      flash[:notice] = "Successfully destroyed entry."
    else
      flash[:notice] = "Not destroyed."
    end
    redirect_to conversions_url
  end
  
  def index
    if params[:dictionary]
      current_user.update_attribute(:dictionary_user_id, params[:dictionary])
    end
    if params[:level]
      current_user.update_attribute(:level, params[:level])
    end
    if is_editor && params[:save]
      params.each do |k,v|
        if k.to_i.to_s == k
          conversion = Conversion.find_by_id(k.to_i)
          next unless (conversion && current_user.is_admin || conversion.user == current_user)
          conversion.phonetic = v
          phase_radio = params["#{conversion.id}-phase".to_sym]
          conversion.level = phase_radio[:level] if phase_radio
          conversion.save!
        end
      end
    end

    @conversion_search = ConversionSearch.new((params[:conversion_search] || {}).merge(:user => ((current_user && current_user.dictionary_user) || current_user || User.find_by_username('anonymous').dictionary_user)))
    @conversion_search.page = params[:page]
    @conversion_search.find
  end
end
