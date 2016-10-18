class TwitterStatus
  include Mongoid::Document

  field :text, type: String

  embedded_in :twitter_user
end
