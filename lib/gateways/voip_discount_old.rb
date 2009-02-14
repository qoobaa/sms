require "net/http"
require "net/https"

module Gateways
  class VoipDiscount
    HOST = "myaccount.voipdiscount.com"
    PORT = 443
    LOGIN_LOCATION = "/clx/index.php"
    LOGIN_DATA = "part=menu&username=%s&password=%s"
    MESSAGE_LOCATION = "/clx/websms2.php"
    MESSAGE_DATA = "action=send&panel=&message=%s&callerid=%s&bnrphonenumber=%s&sendscheduled=no" #&day=20&month=08&hour=11&minute=12&gmt=1"
    AMOUNT_LOCATION = "/clx/index.php?part=menu"
    LOGOUT_LOCATION = "/clx/index.php?part=logoff"

    def self.login(login, password, &block)
      http = Net::HTTP.new(HOST, PORT)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true if PORT == 443
      http.read_timeout = 60
      http.open_timeout = 60
      http_header = { "User-Agent" => "Mozilla/5.0" }
      response = http.post(LOGIN_LOCATION, LOGIN_DATA % [CGI.escape(login), CGI.escape(password)], http_header.merge("Content-Type" => "application/x-www-form-urlencoded"))
      if response.body =~ /error/i
        return false # cannot log in with given login and password
      else
        return false unless response["Set-cookie"] # no Set-cookie
        return false unless http_header["Cookie"] = response["Set-cookie"].scan(/PHPSESSID=[^;]+/).last # no PHPSESSID in Set-cookie
        yield VoipDiscount.new(http, http_header) if block_given?
        http.get(LOGOUT_LOCATION, http_header)
        true
      end
    rescue SocketError, Timeout::Error => e
      false
    end

    def deliver(from, to, content)
      10.times do
        response = @http.post(MESSAGE_LOCATION, MESSAGE_DATA % [CGI.escape(self.class.translit(content)), CGI.escape(from), CGI.escape(to)], @http_header.merge("Content-Type" => "application/x-www-form-urlencoded"))
        return true if response.body =~ /sent/i
        break unless response.body =~ /session lost/i
      end
      false
    end

    def amount
      10.times do
        response = @http.get(AMOUNT_LOCATION, @http_header)
        return $1.to_f if response.body =~ /<span id="balanceid"><b>&euro;&nbsp;(\d+\.\d\d)<\/b><\/span>/
        break unless response.body =~ /session lost/i
      end
      nil
    end

    protected

    def initialize(http, http_header)
      @http = http
      @http_header = http_header
    end

    def self.translit(string)
      Iconv.iconv('ASCII//TRANSLIT', 'UTF-8', string).first # doesn't work at all
      # %x{echo -n #{string} | iconv -t ASCII//TRANSLIT} # depends on iconv in system !UNSAFE!
    end
  end
end
