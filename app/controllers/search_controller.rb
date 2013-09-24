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
      friend_ids.push(res.ids.flatten)
      cursor = res.next_cursor
    end

    friend_ids.flatten!
    @results = []
    @query = params[:query] || ''
    if @query != ''
      @page = params[:page] || 1
      Twitter.search(@query).results.each do |result|
        @res = {}
        @res["unique_id"] = Digest::MD5.new.update(result.from_user + result.created_at.to_s)
        id = Rails.cache.fetch(result.from_user)
        if not id
          user = Twitter.user(result.from_user)
          id = user.id
          Rails.cache.write(result.from_user, id)
        end

        if friend_ids.index(id)
          @res["is_following"] = true
        end

        @res["from_user"] = result.from_user
        @res["profile_image_url"] = result.profile_image_url
        @res["text"] = result.text

        @results << @res
      end
    end
  end
end
