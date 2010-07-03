require 'devise/orm/active_record'

config = Rails.application.config
config.middleware.insert(Warden::Manager, Rack::OpenID)

config.devise.encryptor = :bcrypt
config.devise.scoped_views = true
config.devise.warden do |manager|
  manager.default_strategies(:openid, :scope => Devise.default_scope)
end

Warden::OpenID.configure do |config|
  config.required_fields = User.required_open_id_fields
  config.optional_fields = User.optional_open_id_fields
  config.user_finder do |response|
    user = User.find_by_identity_url(response.identity_url)
    if user.nil?
      user = User.new
      user.extract_open_id_values(response)
      unless user.save
        pp user
        pp user.errors
        # TODO: log it.
        user = nil
      end
    end
    user
  end
end
