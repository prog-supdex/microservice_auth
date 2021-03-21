RSpec.describe Users::CreateService do
  subject { described_class }

  context 'valid parameters' do
    it 'creates a new user' do
      expect { subject.call(name: 'bob', email: 'bob@example.com', password: 'givemeatoken', password_confirmation: 'givemeatoken') }
        .to change { User.count }.from(0).to(1)
    end

    it 'assigns user' do
      result = subject.call(name: 'bob', email: 'bob@example.com', password: 'givemeatoken', password_confirmation: 'givemeatoken')

      expect(result.user).to be_kind_of(User)
    end
  end

  context 'invalid parameters' do
    it 'does not create user' do
      expect { subject.call(name: 'bob', email: 'bob@example.com', password: '', password_confirmation: '') }
        .not_to change { User.count }
    end

    it 'assigns user' do
      result = subject.call(name: 'bob', email: 'bob@example.com', password: '', password_confirmation: '')

      expect(result.user).to be_kind_of(User)
    end
  end
end
