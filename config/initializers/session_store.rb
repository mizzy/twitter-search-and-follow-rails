# Be sure to restart your server when you modify this file.

#TwitterSearchAndFollow::Application.config.session_store :cookie_store, key: '_twitter-search-and-follow_session'

TwitterSearchAndFollow::Application.config.session_store :mem_cache_store, {
  memcache_server: [ ENV['MEMCACHE_SERVERS'] ],
  key:             ENV['MEMCACHE_USERNAME'],
  secret:          ENV['MEMCACHE_PASSWORD']
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# TwitterSearchAndFollow::Application.config.session_store :active_record_store
