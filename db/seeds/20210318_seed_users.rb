Sequel.seed(:development, :test) do
  require_relative '../../config/environment'

  def run
    User.create(
      {
        name: 'Bob',
        email: 'bob@example.com',
        password: 'givemeatoken',
        password_confirmation: 'givemeatoken'
      }
    )
  end
end
