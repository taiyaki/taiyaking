smtp_yml = Rails.root + "config" + "smtp.yml"
if smtp_yml.exist?
  smtp_configurations = YAML.load(smtp_yml.read)
  smtp_configuration = smtp_configurations[Rails.env]
  if smtp_configuration
    notifiers = [Racknga::ExceptionMailNotifier.new(searcher_options[:smtp])]
    config = Rails.application.config
    config.middleware.insert_after(ActionDispatch::ShowExceptions,
                                   Racknga::Middleware::ExceptionNotifier,
                                   :notifiers => notifiers)
  end
end
