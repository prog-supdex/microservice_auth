# Тут можно определить configure(:production)/configure(:development) и в них все описать
# но выходит дублирование, потому и определяю внутри одного configure и проверяю на environment
Application.configure do |app|
  logger = Ougai::Logger.new(
    app.development? ? STDOUT : "#{app.opts[:root]}/#{Settings.logger.path}",
    level: Settings.logger.level
  )

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]
  end

  if app.development?
    logger.formatter = Ougai::Formatters::Readable.new
  end

  app.opts[:custom_logger] = logger
end

Sequel::Model.db.loggers.push(Application.opts[:custom_logger])
