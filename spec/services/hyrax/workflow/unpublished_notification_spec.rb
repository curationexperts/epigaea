libdir = File.expand_path('../../../../', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'rails_helper'
require 'active_fedora/cleaner'
require 'tufts/workflow_setup'
require 'database_cleaner'

RSpec.describe Hyrax::Workflow::UnpublishedNotification do
  before :all do
    Tufts::WorkflowSetup.setup
  end
  let(:depositor) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:work) { FactoryGirl.create(:pdf, depositor: depositor.user_key) }
  let(:ability) { ::Ability.new(depositor) }
  let(:recipients) do
    { 'to' => [depositor] }
  end
  let(:notification) do
    current_ability = ::Ability.new(depositor)
    admin # ensure admin user exists
    attributes = {}
    env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
    Hyrax::CurationConcern.actor.create(env)
    work_global_id = work.to_global_id.to_s
    entity = Sipity::Entity.where(proxy_for_global_id: work_global_id).first
    described_class.new(entity, '', depositor, recipients)
  end
  it "can instantiate" do
    expect(notification).to be_instance_of(described_class)
  end
  it "can find depositor" do
    expect(notification.depositor).to be_instance_of(::User)
    expect(notification.depositor.email).to eq depositor.user_key
  end
  it "can find admins" do
    expect(notification.admins).to be_instance_of(Array)
    expect(notification.admins.pluck(:id)).to contain_exactly(admin.id)
  end
  it "sends notifications to application admins and no one else" do
    expect(notification.recipients["to"].pluck(:email)).to contain_exactly(admin.user_key)
  end
end
