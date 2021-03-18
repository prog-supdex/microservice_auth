class AppRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.on 'v1/auth',   proc { r.run AuthRoutes }
    r.on 'v1/signup', proc { r.run UserRoutes }
    r.on 'v1/login',  proc { r.run UserSessionRoutes }
  end
end
