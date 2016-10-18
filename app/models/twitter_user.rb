class TwitterUser
  include Mongoid::Document

  field :screen_name, type: String
  field :expires_at, type: DateTime

  embeds_many :twitter_statuses, store_as: "statuses" do
    def text
      @target.map { |status| status.text }
    end
  end

  before_save do |document|
    document.expires_at = DateTime.now + 5.minutes
  end

  before_create do |document|
    document.expires_at = DateTime.now + 5.minutes
  end
end
