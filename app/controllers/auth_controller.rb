class AuthController < ApplicationController
  def auth
    request_token = oauth_consumer.get_request_token(
        oauth_callback: ENV['TWITTER_OAUTH_CALLBACK_URL']
    )

    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def callback
    request_token = OAuth::RequestToken.new(
        oauth_consumer,
        session[:request_token],
        session[:request_token_secret],
    )
    session[:access_token] = request_token.get_access_token(
        oauth_token:    params[:oauth_token],
        oauth_verifier: params[:oauth_verifier],
    )
    redirect_to search_url
  end

  private
  def oauth_consumer 
    OAuth::Consumer.new(
        ENV['TWITTER_CONSUMER_KEY'],
        ENV['TWITTER_CONSUMER_SECRET'],
        site: 'https://api.twitter.com'
     )
  end

end
