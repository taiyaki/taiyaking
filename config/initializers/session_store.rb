# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

session_secret_file = File.join(RAILS_ROOT, "config", "session_secret.txt")
unless File.exist?(session_secret_file)
  File.open(session_secret_file, "w") do |file|
    file.puts(ActiveSupport::SecureRandom.hex(64))
  end
end
session_secret = File.read(session_secret_file).strip

config.action_controller.session = {
  :session_key => '_taiyaking_session',
  :secret      => session_secret,
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# config.action_controller.session_store = :active_record_store
