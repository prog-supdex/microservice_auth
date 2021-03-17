module Users
  class CreateService
    prepend BasicService

    option :name
    option :email
    option :password
    option :password_confirmation

    attr_reader :user

    def call
      puts 'create service'
      puts @name.inspect

      @user = ::User.new(
        name: @name,
        email: @email,
        password: @password,
        password_confirmation: @password_confirmation
      )

      if @user.valid?
        @user.save
      else
        fail!(@user.errors)
      end
    end
  end
end
