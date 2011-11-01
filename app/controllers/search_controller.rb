require 'open-uri'
require 'multi_json'

class SearchController < ApplicationController
  def show
    if not session[:access_token]
      redirect_to auth_url
    end

    Twitter.configure do |config|
      config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
      config.oauth_token        = session[:access_token].token
      config.oauth_token_secret = session[:access_token].secret
    end

    if not session[:profile_image_url]
      verify = Twitter.verify_credentials
      session[:profile_image_url] = verify["profile_image_url"]
      session[:screen_name]       = verify["screen_name"]
    end

    @query = params[:query] || ''
    @results = []
    if @query != ''
      @page = params[:page] || 1
      @results = search(@query, @page)["results"]
    end

  end

  private
  def search(query, page=1, rpp=50)
    url = 'http://search.twitter.com/search.json'
    url = sprintf("%s?q=%s&page=%s&rpp=%s", url, URI.encode(query), page, rpp)
    json = open(url).read
    MultiJson.decode(json)
  end
end
