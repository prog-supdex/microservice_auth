require_relative 'config/environment'

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.opts[:custom_logger]

run AppRoutes
