class UserRoutes < Application
  route do |r|
    r.post true do
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
