class AuthRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.post do
      r.on 'sessions/v1' do
        r.is do
          params = JSON.parse(r.body.read)
          session_params = r.validate_with!(validation: UserSessionParamsContract, params: params)
          result = UserSessions::CreateService.call(**session_params.to_h)

          if result.success?
            token = JwtEncoder.encode(uuid: result.session.uuid)
            meta = { token: token }

            response.status = :created

            { meta: meta }
          else
            response.status = :unauthorized
            error_response(result.session || result.errors)
          end
        end
      end

      r.on 'users/v1' do
        r.is do
          params = JSON.parse(r.body.read)
          user_params = r.validate_with!(validation: UserParamsContract, params: params)
          result = Users::CreateService.call(**user_params.to_h)

          if result.success?
            response.status = :created
            nil
          else
            response.status = :unprocessable_entity
            error_response(result.user)
          end
        end
      end
    end
  end
end
