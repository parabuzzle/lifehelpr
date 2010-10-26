# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_active?(page_name, controller)
    if page_name.nil? || controller.nil?
      if controller.nil?
        if params[:action] == page_name
          return 'link_active'
        else
          return 'link_inactive'
        end
      elsif page_name.nil?
        if params[:controller] == controller
          return 'link_active'
        else
          return 'link_inactive'
        end
      else
        return 'link_inactive'
      end
    else
      if params[:action] == page_name && params[:controller] == controller
        return 'link_active'
      else
        return 'link_inactive'
      end
    end
  end
  
end
