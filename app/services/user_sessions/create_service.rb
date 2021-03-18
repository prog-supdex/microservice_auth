module UserSessions
  class CreateService
    prepend BasicService

    option :email
    option :password
    option :user, default: proc { User.where(email: @email).eager_graph(:sessions) }, reader: false

    attr_reader :session

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      puts @user.all[0].inspect
      return fail_t!(:unauthorized) unless @user.all[0]&.authenticate(@password)
    end

    def create_session
      @session = @user.all[0].add_session(UserSession.new)
      if @session.valid?
        @session.save
      else
        fail!(@session.errors)
      end
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.user_sessions.create_service'))
    end
  end
end
