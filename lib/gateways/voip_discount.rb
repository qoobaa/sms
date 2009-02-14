require "net/http"
require "net/https"

module Gateways
  class VoipDiscount
    def initialize(username, password)
      login(username, password)
      yield self if logged_in? and block_given?
    rescue SocketError, Timeout::Error
    end

    def logged_in?

    end

    protected

    def login(username, password)
      @agent = WWW::Mechanize.new { |a| a.log = Logger.new(STDOUT) }
      @agent.get("https://myaccount.voipdiscount.com/clx/loginpanel.php") do |page|
        login_form = page.form_with(:name => "loginpanel") do |form|
          form.user = username
          form.pass = password
        end
        login_form.submit
      end
    end
  end
end
