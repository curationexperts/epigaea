shared_examples 'a Tufts presenter' do
  subject { described_class.new(double, double) }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:request) { double }
  let(:user_key) { 'a_user_key' }

  let(:attributes) do
    { "id" => '888888',
      "title_tesim" => ['foo', 'bar'],
      "human_readable_type_tesim" => ["Generic Work"],
      "has_model_ssim" => ["GenericWork"],
      "date_created_tesim" => ['an unformatted date'],
      "depositor_tesim" => user_keyspec }
  end
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  describe "displays_in" do
    it { is_expected.to delegate_method(:to_s).to(:solr_document) }
  end

  describe "geographic_name" do
    it { is_expected.to delegate_method(:to_s).to(:solr_document) }
  end

  describe "held_by" do
    it { is_expected.to delegate_method(:to_s).to(:solr_document) }
  end
end
