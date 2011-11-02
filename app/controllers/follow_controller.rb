class FollowController < ApplicationController
  def follow
    Twitter.configure do |config|
      config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
      config.oauth_token        = session[:access_token].token
      config.oauth_token_secret = session[:access_token].secret
    end

    Twitter.follow(params[:screen_name], { follow: true })
    res = { code: 200, id: params[:id] }
    render text: MultiJson.encode(res)
  end
end
