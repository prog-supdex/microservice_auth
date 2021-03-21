class AuthRoutes < Application
  plugin :request_headers
  plugin :auth

  route do |r|
    r.post ['', true] do
      result = Auth::FetchUserService.call(uuid: extracted_token['uuid'])

      if result.success?
        response.status = :ok

        { meta: { user_id: result.user.id } }
      else
        response.status = :forbidden
        error_response(result.errors)
      end
    end
  end
end
