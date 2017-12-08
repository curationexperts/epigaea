RSpec.shared_examples 'a work that has transcript UI on the form' do
  let(:ability) { double }
  let(:curation_concern) { work }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "hyrax/base/form_metadata", f: f %>
      <% end %>
     )
  end

  let(:page) do
    assign(:form, form)
    assign(:curation_concern, work)
    allow(form).to receive(:transcript_files).and_return('tei.xml' => '6w924b184')
    allow(form).to receive(:media_files).and_return('sample.mp3' => '6w924b185')
    render inline: form_template
    Capybara::Node::Simple.new(rendered)
  end

  it 'has the transcript UI' do # rubocop:disable RSpec/MultipleExpectations
    expect(page).to have_content('You will need to attach an XML file to to this work to select a transcript.')
    expect(rendered).to match('<option value="6w924b184">tei.xml</option>')
  end
end
