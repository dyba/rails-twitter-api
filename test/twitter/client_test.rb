require 'test_helper'

describe Twitter do
  before(:each) do
    Twitter.setup do |config|
      config.consumer_secret = 'secret'
      config.consumer_key = 'key'
    end
  end

  it "has a consumer key" do
    Twitter.consumer_key.must_equal 'key'
  end

  it "has a consumer secret" do
    Twitter.consumer_secret.must_equal 'secret'
  end
end

describe Twitter::Client do
  before(:each) do
    Twitter.setup do |config|
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    end
  end

  describe "#authorize" do
    it "retrieves an access token" do
      client = Twitter.client

      VCR.use_cassette('oauth_authorize_success') do
        client.authorize

        client.access_token.wont_be_empty
      end
    end
  end

  describe "#user_timeline" do
    it "raises an error when no screen_name or user_id is provided" do
      client = Twitter.client

      proc {
        client.user_timeline
      }.must_raise ArgumentError
    end

    it "retrieves the last 25 tweets of a user's timeline by default" do
      client = Twitter.client

      VCR.use_cassette('oauth_authorize_success') do
        client.authorize
      end

      VCR.use_cassette('user_timeline_success') do
        statuses = client.user_timeline screen_name: 'dyba'

        statuses.count.must_equal 25
      end
    end
  end
end
