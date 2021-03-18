class AppRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.is true,          proc { r.run AuthRoutes }
    r.on 'users/v1',    proc { r.run UserRoutes }
    r.on 'sessions/v1', proc { r.run UserSessionRoutes }
  end
end
