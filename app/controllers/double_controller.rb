class DoubleController < ApplicationController

  def index
  end

  def create
    @english = params[:english]
    @translation = Conversion.convert(@english, current_user)
    @split_english = @english.split(" ")
    @split_translation = @translation.split(" ")
    @line_length = 80
    render :index
  end

end
