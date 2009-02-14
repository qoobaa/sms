require "hpricot"

module Gateways
  class OrangeMultiBox
    def initialize(username, password)
      login(username, password)
      yield self if logged_in? and block_given?
    rescue SocketError, Timeout::Error
    end

    def logged_in?
      @agent.cookies.detect { |cookie| cookie.name == "mapProfileCookie" }
    end

    def amount
      @agent.get("http://www.orange.pl/portal/map/map/message_box") do |page|
        values = Hpricot(page.body) / "span.value"
        return values.inner_html.to_i
      end
    end

    def deliver(to, content)
      initial_amount = amount
      @agent.get("http://www.orange.pl/portal/map/map/message_box?mbox_view=newsms") do |page|
        sms_form = page.form_with(:name => "sendSMS") do |form|
          form["/amg/ptk/map/messagebox/formhandlers/MessageFormHandler.to"] = to
          form["/amg/ptk/map/messagebox/formhandlers/MessageFormHandler.body"] = content
          form["/amg/ptk/map/messagebox/formhandlers/MessageFormHandler.create.x"] = "0"
          form["/amg/ptk/map/messagebox/formhandlers/MessageFormHandler.create.y"] = "0"
        end
        sms_form.submit
      end
      initial_amount > amount
    end

    protected

    def login(username, password)
      @agent = WWW::Mechanize.new
      @agent.get("http://www.orange.pl/portal/map/map/signin") do |page|
        login_form = page.form_with(:name => "loginForm") do |form|
          form["/amg/ptk/map/core/formhandlers/AdvancedProfileFormHandler.value.login"] = username
          form["/amg/ptk/map/core/formhandlers/AdvancedProfileFormHandler.value.password"] = password
          form["/amg/ptk/map/core/formhandlers/AdvancedProfileFormHandler.login.x"] = "0"
          form["/amg/ptk/map/core/formhandlers/AdvancedProfileFormHandler.login.y"] = "0"
        end
        login_form.submit
      end
    end
  end
end
