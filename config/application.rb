class Application < Roda
  plugin :json
  plugin :hash_routes
  plugin :environments
  plugin :symbol_status
  plugin :validations
  plugin :api_errors
  plugin :head

  opts[:root] = File.expand_path('../', __dir__)
end
