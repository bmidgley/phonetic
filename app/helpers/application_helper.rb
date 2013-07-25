# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def demonstrating?
    ['double','translate'].include? controller.controller_name
  end

  def translating?
    (session[:current] != 'double' && controller.controller_name == 'translate') || (session[:current] == 'translate' && controller.controller_name == 'double')
  end

  def doubling?
    (session[:current] != 'translate' && controller.controller_name == 'double') || (session[:current] == 'double' && controller.controller_name == 'translate')
  end
end
