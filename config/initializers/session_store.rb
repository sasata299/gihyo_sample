# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gihyo_sample_session',
  :secret      => '0185b9c2c03da3cc4ddb98726fcbb3e1ce23da9d18562e9162f85843bbed7a352dd44bc9fb51ef4345b29ba49f96958d3716dc18ba21bc4978c21a64af711985'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
