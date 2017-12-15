require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }
  let(:plain_user) { create(:user) }

  it_behaves_like 'a Hyrax User'

  it "has a display name" do
    expect(user.display_name).not_to be_empty
  end

  it '#to_s yields the #display_name' do
    expect(user.to_s).to eq user.display_name
  end

  it "#to_s yields the user_key if display_name is blank" do
    user.display_name = nil
    expect(user.to_s).to eq user.user_key
  end

  describe '#name' do
    subject(:user) { build(:user, display_name: name) }
    let(:name)     { 'MoominMama' }

    it 'does not try to normalize names' do
      expect(user.name).to eq name
    end
  end

  describe 'roles' do
    it 'is emplty for a new user' do
      new_user = create(:user)
      expect(new_user.roles).to be_empty
    end

    it "#add_role adds a named role" do
      plain_user.add_role('some_role')
      expect(plain_user.roles.inspect).to match(/some_role/)
    end

    it "#add_role creates a new role if needed" do
      expect { plain_user.add_role('named_role') }.to change { Role.count }.by(1)
    end

    it "#add_role uses an existing role if it exists" do
      role = Role.create(name: 'existing_role')
      plain_user.add_role('existing_role')
      expect(plain_user.roles.to_a).to include role
    end

    it "#remove_role removes a named role" do
      new_user = create(:user)
      new_user.add_role('new_role')
      expect { new_user.remove_role('new_role') }.to change { new_user.roles.count }.from(1).to(0)
    end

    it "#remove_role does nothing on non-existant names" do
      existing_roles = plain_user.roles
      plain_user.remove_role('nonexistent_role_name')
      expect(plain_user.roles).to match existing_roles
    end
  end

  describe '#admin?' do
    it 'is false for regular user' do
      expect(user).not_to be_admin
    end

    it 'is true when a user has the "admin" role' do
      admin_user = create(:user)
      admin_user.add_role(:admin)
      expect(admin_user).to be_admin
    end
  end

  describe '#username' do
    it "has a username" do
      expect(user.username).not_to be_blank
    end
  end
end
