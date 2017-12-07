require 'rails_helper'

RSpec.describe ResourceTypeRenderer do
  subject(:renderer) { described_class.new(field, values) }
  let(:field)        { :resource_type }
  let(:labels)       { ['Collection', 'Image'] }

  let(:values) { ['http://purl.org/dc/dcmitype/Collection', 'http://purl.org/dc/dcmitype/Image'] }

  describe '#render' do
    it 'has the labels' do
      expect(renderer.render).to include(*labels)
    end

    context 'with unexpected values' do
      let(:values) { ['moomin', 'hattifatteners'] }

      it 'shows the values instead' do
        expect(renderer.render).to include(*values)
      end
    end
  end
end
