class DoubleController < ApplicationController

  def index
  end

  def create
    level = params[:level] && params[:level].to_i
    session[:level] = level
    @english = params[:english]
    @translation = Conversion.convert(@english, current_user, level)

    translation = Conversion.convert(@english, current_user, 8)
    @split_english = @english.split(" ")
    @split_translation = translation.split(" ")
    @line_length = 80
    if params['commit']
      session[:current] = 'double'
      render :index
    else
      session[:current] = 'translate'
      render 'translate/index'
    end
  end

end
