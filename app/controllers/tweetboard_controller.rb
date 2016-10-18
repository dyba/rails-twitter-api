class TweetboardController < ApplicationController
  http_basic_authenticate_with name: 'stack-commerce', password: 'commerce!'

  def search
    if params[:screen_name]
      user = TwitterUser.find_by(screen_name: params[:screen_name])

      if user
        if user.expires_at > DateTime.now
          user.twitter_statuses = twitter_user_statuses(params[:screen_name])
          user.save
        end

        @statuses = user.statuses
      end
    else
      @statuses = []
    end
  rescue Mongoid::Errors::DocumentNotFound => e
    if params[:screen_name].empty?
    else
      user = TwitterUser.create(screen_name: params[:screen_name])
      statuses = twitter_user_statuses(params[:screen_name])
      @statuses = statuses
    end
  end

  private

  def twitter_user_statuses(screen_name)
    tw_client = Twitter.client
    tw_client.authorize
    tw_client.user_timeline screen_name: screen_name
  end
end
