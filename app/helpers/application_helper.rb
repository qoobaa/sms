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

#   def link_to_unless_current_controller(name, options, html_options = {}, &block)
#     html_options[:class] = html_options[:class].to_s
#     html_options[:class] << (current_controller?(options) ? " active" : "")
#     html_options[:class].strip!
#     link_to(name, options, html_options, &block)
#   end

#   def link_to_unless_current_action(name, options, html_options = {}, &block)
#     link_to_unless current_action?(options), name, options, html_options, &block
#   end

  def navigation_item(name, options, html_options = {}, &block)
    if current_controller?(options)
      html_class = html_options[:class].to_s
      html_class << " active"
      html_options[:class] = html_class.strip
    end
    content_tag :li, html_options do
      link_to(name, options, html_options, &block)
    end
  end

  def menu_item(name, options, html_options = {}, &block)
    if current_action?(options)
      html_class = html_options[:class].to_s
      html_class << " active"
      html_options[:class] = html_class.strip
    end
    content_tag :li, html_options do
      link_to(name, options, html_options, &block)
    end
  end
end
