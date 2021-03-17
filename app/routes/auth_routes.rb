class AuthRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.post do
      r.on 'sessions/v1' do
        r.is do

        end
      end

      r.on 'users/v1' do
        r.is do
          params = JSON.parse(r.body.read)
          user_params = r.validate_with!(validation: UserParamsContract, params: params)

          result = Users::CreateService.call(**user_params)

          if result.success?
            response.status = :created
          else
            error_response(result.user, :unprocessable_entity)
          end
        end
      end
    end
  end
end
