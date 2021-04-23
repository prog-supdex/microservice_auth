require_relative 'config/environment'

# Необходимо добавить, так как есть гем, который грузит через гит
require 'bundler'
Bundler.setup(:default)

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.opts[:custom_logger]

run AppRoutes
