libdir = File.expand_path('../../../../', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'rails_helper'

RSpec.describe Hyrax::Workflow::BatchImportNotification do
  let(:admin) { create(:admin) }
  let(:batch) { create(:batch) }
  let(:notification) do
    admin # ensure admin user exists before the notification is created
    described_class.new(batch)
  end
  it "can find admins" do
    expect(notification.admins).to be_instance_of(Array)
    expect(notification.admins.pluck(:id)).to include(admin.id)
  end
  it "has a subject" do
    expect(notification.subject).to eq("XML Import Batch #{batch.id}")
  end
  it "has a message" do
    expect(notification.message).to match(/http/)
    expect(notification.message).to match(/XML Import Batch #{batch.id}/)
  end
end
