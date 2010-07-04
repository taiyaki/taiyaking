smtp_yml = Rails.root + "config" + "smtp.yml"
if smtp_yml.exist?
  smtp_configurations = YAML.load(smtp_yml.read)
  smtp_configuration = smtp_configurations[Rails.env]
  if smtp_configuration
    require 'nkf' # for racknga 0.9.0
    notifiers = [Racknga::ExceptionMailNotifier.new(smtp_configuration)]
    config = Rails.application.config
    config.middleware.insert_after(ActionDispatch::ShowExceptions,
                                   Racknga::Middleware::ExceptionNotifier,
                                   :notifiers => notifiers)
  end
end
