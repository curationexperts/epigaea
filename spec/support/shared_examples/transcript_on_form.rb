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
    render inline: form_template
    Capybara::Node::Simple.new(rendered)
  end

  it 'has the transcript UI' do
    expect(page).to have_content('You will need to attach an XML file to to this work to select a transcript.')
  end
end
