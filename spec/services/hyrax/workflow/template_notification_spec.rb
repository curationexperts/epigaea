libdir = File.expand_path('../../../../', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'rails_helper'
require 'active_fedora/cleaner'
require 'database_cleaner'
require 'ffaker'

RSpec.describe Hyrax::Workflow::TemplateNotification, :workflow do
  let(:admin) { create(:admin) }
  let(:template_name) { FFaker::Book.title }
  let(:count) { 25 }
  let(:batch) { create(:batch) }
  let(:user) { create(:user) }
  let(:notification) do
    admin # ensure admin user exists before the notification is created
    described_class.new(template_name: template_name, count: count, batch: batch, user: user)
  end
  it "can find admins" do
    expect(notification.admins).to be_instance_of(Array)
    expect(notification.admins.pluck(:id)).to include(admin.id)
  end
  it "has a subject" do
    expect(notification.subject).to eq("Template #{template_name}")
  end
  it "has a message" do
    expect(notification.message).to eq("Template '#{template_name}' has been applied to #{count} objects in batch #{batch.id} by #{user.display_name} (#{user.email}).")
  end
end
