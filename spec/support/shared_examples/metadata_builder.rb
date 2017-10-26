shared_examples 'a MetadataBuilder' do
  subject(:builder) { described_class.new }

  describe '#add' do
    let(:object)        { objects.first }
    let(:objects)       { FactoryGirl.create_list(:pdf, 2) }
    let(:property_keys) { objects.first.class.properties.keys }

    let(:values) do
      objects.each_with_object([]) do |object, arry|
        attributes = object.attributes.slice(*property_keys)
        arry.concat(attributes.values.map { |vals| Array(vals) }.flatten)
      end
    end

    it 'adds the object ids' do
      expect { builder.add(*objects) }
        .to change { builder.build }
        .to include(*objects.map(&:id))
    end

    it 'adds the object models' do
      expect { builder.add(*objects) }
        .to change { builder.build }
        .to include(":hasModel>#{object.class}</")
    end

    it 'adds the object attributes' do
      expect { builder.add(*objects) }
        .to change { builder.build }
        .to include(*values)
    end

    it 'adds datatypes' do
      object.date_accepted = [Time.zone.today]

      expect { builder.add(*objects) }
        .to change { builder.build }
        .to include('datatype=')
    end

    context 'with uris' do
      before do
        object.replaces = objects
        object.save!
      end

      it 'handles uris' do
        expect { builder.add(*objects) }
          .to change { builder.build }
          .to include "uri=\"#{object.rdf_subject}\""
      end
    end
  end

  describe '#build' do
    it 'builds a string' do
      expect(builder.build.to_str).to be_a String
    end
  end

  describe '#file_extension' do
    it 'is an extension' do
      expect(builder.file_extension).to match(/^\.[a-z]+$/)
    end
  end
end
