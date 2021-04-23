Application.configure do |app|
  logger = Ougai::Logger.new(
    app.production? ? STDOUT : "#{app.opts[:root]}/#{Settings.logger.path}",
    level: Settings.logger.level
  )

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]
  end

  logger.formatter = Ougai::Formatters::Readable.new if app.development?

  app.opts[:custom_logger] = logger
end

Sequel::Model.db.loggers.push(Application.opts[:custom_logger])
