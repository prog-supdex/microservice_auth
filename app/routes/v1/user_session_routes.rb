class UserSessionRoutes < Application
  route do |r|
    r.post true do
      params = JSON.parse(r.body.read)
      session_params = r.validate_with!(validation: UserSessionParamsContract, params: params)
      result = UserSessions::CreateService.call(**session_params.to_h)

      if result.success?
        token = JwtEncoder.encode(uuid: result.session.uuid)
        response.status = :created

        { meta: { token: token } }
      else
        response.status = :unauthorized
        error_response(result.session || result.errors)
      end
    end
  end
end
