require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Display Handle errors on the log page', js: true do
  scenario do
    begin
      handle_registrar = Tufts::HandleRegistrar.new
      handle_registrar.register!(object: Pdf.new)
    rescue; end # rubocop:disable Lint/HandleExceptions
    visit '/handle/log.html'
    expect(page).to have_content 'Unable to register handle'
  end
end
