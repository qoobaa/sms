module ApplicationHelper
  def current_action?(options)
    url_string = CGI.escapeHTML(url_for(options))
    params = ActionController::Routing::Routes.recognize_path(url_string, :method => :get)
    params[:controller] == @controller.controller_name && params[:action] == @controller.action_name
  end

  def current_controller?(options)
    url_string = CGI.escapeHTML(url_for(options))
    params = ActionController::Routing::Routes.recognize_path(url_string, :method => :get)
    params[:controller] == @controller.controller_name
  end

  def link_to_unless_current_controller(name, options, html_options = {}, &block)
    link_to_unless current_controller?(options), name, options, html_options, &block
  end

  def link_to_unless_current_action(name, options, html_options = {}, &block)
    link_to_unless current_action?(options), name, options, html_options, &block
  end
end
