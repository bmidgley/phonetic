class TranslateController < ApplicationController

  def index
    if params[:english]
      @english = params[:english]
      @translation = Conversion.convert(@english, current_user)
    end
  end

end
