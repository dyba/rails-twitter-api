require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<BASE64_CREDENTIALS>') {
    encoded_credentials = "#{URI.encode(ENV['TWITTER_CONSUMER_KEY'])}:#{URI.encode(ENV['TWITTER_CONSUMER_SECRET'])}"
    Base64.strict_encode64(encoded_credentials)
  }
end
