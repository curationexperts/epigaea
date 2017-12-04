RSpec.shared_examples 'a work that has no transcript UI on the form' do
  let(:ability) { double }

  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "hyrax/base/form_metadata", f: f %>
      <% end %>
     )
  end

  let(:page) do
    assign(:form, form)
    render inline: form_template
    Capybara::Node::Simple.new(rendered)
  end

  it 'has the transcript UI' do
    expect(page).not_to have_content('You will need to attach an XML file to to this work to select a transcript.')
  end
end
