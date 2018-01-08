require 'rails_helper'

RSpec.describe MetadataImport, :clean, type: :model do
  subject(:batchable) { FactoryGirl.create(:metadata_import) }
  let(:mira_export_ids) { ['sx61dm28w', '37720c723', 'cz30ps66x', 'hh63sv88v', 'k0698748f'] }

  before do
    mira_export_ids.each do |id|
      FactoryGirl.create(:pdf, id: id)
    end
  end

  it_behaves_like 'a batchable' do
    let(:parser) { parser_class.new(ids: ids) }

    # rubocop:disable RSpec/InstanceVariable
    let(:parser_class) do
      Class.new do
        def initialize(ids:)
          @ids = ids
        end

        def records
          @ids.map { |id| ImportRecord.new(id: id) }
        end

        class ImportRecord
          attr_accessor :id

          def initialize(id: '')
            @id = id
          end
        end
      end
    end
    # rubocop:enable RSpec/InstanceVariable
    before { batchable.parser = parser }
  end

  it { is_expected.to have_attributes(batch_type: 'Metadata Import') }

  describe '#enqueue' do
    it 'enqueues an import job for each record' do
      ActiveJob::Base.queue_adapter = :test

      expect { batchable.enqueue! }
        .to enqueue_job(MetadataImportJob)
        .exactly(5).times
    end
  end

  describe '#ids' do
    it 'has ids parsed from the file' do
      expect(batchable.ids)
        .to contain_exactly("37720c723", "cz30ps66x", "hh63sv88v", "k0698748f", "sx61dm28w")
    end
  end

  describe '#metadata_file' do
    subject(:batchable) { FactoryGirl.build(:metadata_import, metadata_file: nil) }
    let(:file)          { file_fixture('mira_export.xml') }

    it 'is an uploader' do
      expect { batchable.metadata_file = File.open(file) }
        .to change { batchable.metadata_file }
        .to(an_instance_of(Tufts::MetadataFileUploader))
    end
  end
end
