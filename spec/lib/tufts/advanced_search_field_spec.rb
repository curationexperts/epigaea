# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tufts::AdvancedSearchField do
  let(:advanced_search_field) { described_class }
  it 'returns _dtsi suffix for date_modified' do
    expect(advanced_search_field.solr_suffix('date_modified')).to eq('date_modified_dtsi')
  end

  it 'returns _dtsi suffix for date_uploaded ' do
    expect(advanced_search_field.solr_suffix('date_uploaded')).to eq('date_uploaded_dtsi')
  end

  it 'returns _tesim for other fields' do
    expect(advanced_search_field.solr_suffix('title')).to eq('title_tesim')
  end
end
