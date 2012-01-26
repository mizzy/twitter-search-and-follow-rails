require 'open-uri'
require 'multi_json'

class SearchController < ApplicationController
  def show
    if not session[:access_token]
      redirect_to auth_url
      return
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

    friend_ids = []
    cursor = -1
    while cursor != 0
      res = Twitter.friend_ids(cursor: cursor)
      friend_ids.push(res["ids"].flatten)
      cursor = res["next_cursor"]
    end

    friend_ids.flatten!

    @query = params[:query] || ''
    @results = []
    if @query != ''
      @page = params[:page] || 1
      @results = search(@query, @page)["results"]
      @results.each do |result|
        result["unique_id"] = Digest::MD5.new.update(result["from_user"] + result["created_at"])
        id = Rails.cache.fetch(result["from_user"])
        if not id
          user = Twitter.user(result["from_user"])
          id = user["id"]
          Rails.cache.write(result["from_user"], id)
        end

        if friend_ids.index(id)
          result["is_following"] = true
        end
      end
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
