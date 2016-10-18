require "net/http"
require "base64"
require "open-uri"
require "json"

module Twitter
  class << self
    def client
      Client.new consumer_secret: self.consumer_secret, consumer_key: self.consumer_key
    end
  end

  class Client
    attr_reader :access_token

    def initialize(consumer_secret:, consumer_key:)
      @consumer_secret, @consumer_key = consumer_secret, consumer_key
    end

    def user_timeline(screen_name: '', user_id: -1, count: 25)
      raise ArgumentError, "You must provide a screen_name or user_id" if screen_name.strip.empty? && user_id == -1

      uri = URI('https://api.twitter.com/1.1/statuses/user_timeline.json')
      params = { count: count }

      if screen_name.empty?
        params.merge!({ user_id: user_id })
      else
        params.merge!({ screen_name: screen_name })
      end

      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{@access_token}"
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        JSON.parse(res.body, symbolize_names: true)
      else
        []
      end
    end
    
    def authorize
      encoded_credentials = "#{URI.encode(@consumer_key)}:#{URI.encode(@consumer_secret)}"
      base64_credentials = Base64.strict_encode64(encoded_credentials)
      uri = URI('https://api.twitter.com/oauth2/token')
      req = Net::HTTP::Post.new(uri)
      req.set_form_data('grant_type' => 'client_credentials')
      req['Authorization'] = "Basic #{base64_credentials}"
      req['Content-Type'] = "application/x-www-form-urlencoded;charset=UTF-8"
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        @access_token = JSON.parse(res.body, symbolize_names: true)[:access_token]
      else
        nil
      end
    end
  end
end
