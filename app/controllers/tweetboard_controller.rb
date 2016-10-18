class TweetboardController < ApplicationController
  http_basic_authenticate_with name: 'stack-commerce', password: 'commerce!'

  def search
    if params[:screen_name]
      user = TwitterUser.find_by(screen_name: params[:screen_name])

      if user
        if user.expires_at > DateTime.now
          user.statuses = twitter_user_statuses(params[:screen_name])
          user.save
        end

        @statuses = user.statuses.text
      else
        @statuses = twitter_user_statuses(params[:screen_name]).text
      end
    else
      @statuses = []
    end
  end

  private

  def twitter_user_statuses(screen_name)
    tw_client = Twitter.client
    tw_client.user_timeline screen_name: screen_name
  end
end
