module Twitter
  class << self
    attr_accessor :consumer_key, :consumer_secret

    def setup
      yield self
    end
  end
end

require 'twitter/client'
