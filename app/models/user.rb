class User < Sequel::Model
  plugin :secure_password

  NAME_FORMAT = %r{\A\w+\z}

  one_to_many :sessions, class_name: 'UserSession'

  def validate
    super

    validates_presence :name,
                       message: I18n.t(:blank, scope: 'model.errors.user.name')
    validates_presence :email,
                       message: I18n.t(:blank, scope: 'model.errors.user.email')

    validates_format NAME_FORMAT, :name, message: I18n.t(:format, scope: 'model.errors.user.name')
  end
end
