# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/_attribute_rows.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/attribute_rows', presenter: presenter
    Capybara::Node::Simple.new(rendered)
  end

  let(:ability)       { double }
  let(:presenter)     { Hyrax::PdfPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:work)          { FactoryGirl.build(:pdf) }
  let(:form) do
    Hyrax::PdfForm.new(work, ability, controller)
  end
  it { is_expected.to have_content('Bostonian Society License') }
  it_behaves_like 'a work that has no transcript UI on the form'
end
