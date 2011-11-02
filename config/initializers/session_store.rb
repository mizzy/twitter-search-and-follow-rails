# Be sure to restart your server when you modify this file.

#TwitterSearchAndFollow::Application.config.session_store :cookie_store, key: '_twitter-search-and-follow_session'

#TwitterSearchAndFollow::Application.config.session_store :mem_cache_store, {
#  memcache_server: [ ENV['MEMCACHE_SERVERS'] ],
#  username:        ENV['MEMCACHE_USERNAME'],
#  password:        ENV['MEMCACHE_PASSWORD']
#}

require 'action_dispatch/middleware/session/dalli_store'


TwitterSearchAndFollow::Application.config.session_store :dalli_store,
  memcache_server: [ ENV['MEMCACHE_SERVERS'] ],
  username:        ENV['MEMCACHE_USERNAME'],
  password:        ENV['MEMCACHE_PASSWORD']
