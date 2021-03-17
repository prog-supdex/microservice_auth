task :settings do
  if ENV['RACK_ENV'] == 'development'
    require 'dotenv/load'
  end

  require 'config'
  require_relative '../config/initializers/config'
end
