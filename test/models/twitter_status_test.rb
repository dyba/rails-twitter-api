require "test_helper"

describe TwitterStatus do
  let(:twitter_status) { TwitterStatus.new }

  it "must be valid" do
    value(twitter_status).must_be :valid?
  end
end
