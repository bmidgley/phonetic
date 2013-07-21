# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def demonstrating?
    ['double','translate'].include? controller.controller_name
  end

  def translating?
    session[:current] != 'double' && demonstrating?
  end

  def doubling?
    session[:current] != 'translate' && demonstrating?
  end
end
