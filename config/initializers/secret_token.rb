# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

session_secret_file = Rails.root + "config" + "session_secret.txt"
unless session_secret_file.exist?
  session_secret_file.open("w") do |file|
    file.puts(ActiveSupport::SecureRandom.hex(64))
  end
end
session_secret = session_secret_file.read.strip

Taiyaking::Application.config.secret_token = session_secret
