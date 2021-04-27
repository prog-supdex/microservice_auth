require_relative 'config/environment'

# Необходимо добавить, так как есть гем, который грузит через гит
require 'bundler'
Bundler.setup(:default)

use Rack::Runtime
use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.opts[:custom_logger]

run AppRoutes
