require "net/http"
require "net/https"

# MINI HOWTO
# Gateways.orange_multi_box("username", "password") do |orange_multi_box|
#   amount = orange_multi_box.amount
#   delivered = orange_multi_box.deliver("500555555", "test")
# end

module Gateways
  class OrangeMultiBox
    HOST = "orange.pl"
    PORT = 443
    LOGIN_LOCATION = "/portal/map/map/homeog?_DARGS=/gear/static/home/login.jsp.loginFormId"
    MESSAGE_LOCATION = "/portal/map/map/message_box?_DARGS=/gear/mapmessagebox/smsform.jsp"
    MESSAGEBOX_LOCATION = "/portal/map/map/message_box"
    LOGIN_DATA = "_dyncharset=UTF-8&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.loginErrorURL=%%2Fportal%%2Fmap%%2Fmap%%2Fsignin&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.loginErrorURL=+&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.loginSuccessURL=http%%3A%%2F%%2Fwww.orange.pl%%2Fportal%%2Fmap%%2Fmap%%2Fyour_account&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.loginSuccessURL=+&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.value.login=%s&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.value.login=+&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.value.password=%s&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.value.password=+&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.login.x=99&%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.login.y=7&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fcore%%2Fformhandlers%%2FAdvancedProfileFormHandler.login=+&_DARGS=%%2Fgear%%2Fstatic%%2Fhome%%2Flogin.jsp.loginFormId"
    MESSAGE_DATA = "_dyncharset=UTF-8&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.type=sms&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.type=+&enabled=false&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.errorURL=%%2Fportal%%2Fmap%%2Fmap%%2Fmessage_box%%3Fmbox_view%%3Dnewsms&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.errorURL=+&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.successURL=%%2Fportal%%2Fmap%%2Fmap%%2Fmessage_box%%3Fmbox_view%%3Dmessageslist&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.successURL=+&smscounter=1&counter=640&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.to=%s&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.to=+&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.body=+&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.body=%s&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.create.x=25&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.create.y=5&%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.create=Wy%%C5%%9Blij&_D%%3A%%2Famg%%2Fptk%%2Fmap%%2Fmessagebox%%2Fformhandlers%%2FMessageFormHandler.create=+&_DARGS=%%2Fgear%%2Fmapmessagebox%%2Fsmsform.jsp"

    def self.login(username, password, &block)
      http = Net::HTTP.new(HOST, PORT)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true if PORT == 443
      http.read_timeout = 60
      http.open_timeout = 60
      http_header = { "User-Agent" => "Mozilla/5.0", "Content-Type" => "application/x-www-form-urlencoded" }
      response = http.post(LOGIN_LOCATION, LOGIN_DATA % [CGI.escape(username), CGI.escape(password)], http_header)
      cookies = []
      [/VisitorId=[^;]+/, /mapProfileCookie=[^;]+/, /JSESSIONID=[^;]+/, /SID=[^;]+/, /ATG_SESSION_ID=[^;]+/, /mapSecurityCookie=[^;]+/].each do |regexp|
        cookies << $& if response["Set-cookie"] =~ regexp
      end
      if cookies.size == 6
        http_header = { "User-Agent" => "Mozilla/5.0", "Cookie" => cookies.join("; ") }
        yield OrangeMultiBox.new(http, http_header) if block_given?
        true
      end
      rescue SocketError, Timeout::Error
        false
    end

    def amount
      response = @http.get(MESSAGEBOX_LOCATION, @http_header)
      $1.to_i if response.body =~ /<span class="value">(\d+)<\/span>/
    end

    def deliver(to, content)
      initial_amount = amount
      @http.post(MESSAGE_LOCATION, MESSAGE_DATA % [CGI.escape(to), CGI.escape(content)], @http_header)
      initial_amount > amount
    end

    protected

    def initialize(http, http_header)
      @http = http
      @http_header = http_header
    end
  end
end
