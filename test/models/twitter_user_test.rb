require "test_helper"

describe TwitterUser do
  let(:twitter_user) { TwitterUser.new }

  it "must be valid" do
    value(twitter_user).must_be :valid?
  end

  describe "after saving" do
    it "updates the expired_at timestamp" do
      Timecop.freeze(Date.today) do
        twitter_user.expires_at.must_equal nil

        twitter_user.save

        dt = DateTime.now + 5.minutes

        twitter_user.expires_at.must_equal dt
      end
    end
  end
end
