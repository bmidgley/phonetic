class TranslateController < ApplicationController

  def index
  end

  def create
    level = params[:level] && params[:level].to_i
    session[:level] = level
    @english = params[:english]
    @translation = Conversion.convert(@english, current_user, level)
    render :index
  end

end
