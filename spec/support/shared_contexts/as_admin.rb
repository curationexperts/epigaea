RSpec.shared_context 'as admin' do
  let(:user) { FactoryGirl.create(:admin) }
  before     { sign_in user }
end
