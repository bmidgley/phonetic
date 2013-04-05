class TranslateController < ApplicationController

  def index
    if params[:english]
      level = params[:level] && params[:level].to_i
      session[:level] = level
      @english = params[:english]
      @translation = Conversion.convert(@english, current_user, level)
    end
  end

end
