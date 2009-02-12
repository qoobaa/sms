# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sms_session',
  :secret      => '3eb5a36967e8529c29d1f86b21ba8b1c081b2f08d80376376e3ba0ab63282edf1efc243f008a29085118bb9943c8f1b2dcac9196aa25d25ed1cf1b6acc73dcdd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
