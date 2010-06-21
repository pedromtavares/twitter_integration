# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twitter_integration_session',
  :secret      => 'afbbd33f3eb21aaf0138830335cc1865f4c51882c6851be48c0f5d8ec7e1ba97c54a5a48d637f8da2eea8cce479a0b172b0fabcf8ad557e2786f5d2978d225d0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
