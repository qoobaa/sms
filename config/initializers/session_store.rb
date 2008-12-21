# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :session_key => '_sms_session',
  :secret      => '425aaa9690224e26ae71333073b5a87312eeca1df3b554aa2b8b8b7b9320f8ef905fcd0addb5afe6327c795c4a0812553028de0fe5ff82b5dcfd5c2d33685d3b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
