# This is a test email generator. Use it to test whether email is configured
# correctly on the server, without generating real mail that will spam lots
# of people.
# To use, launch a rails console and type:
# TestMailer.test_email.deliver
class TestMailer < ApplicationMailer
  def test_email
    mail(
      from: "bess@curationexperts.com",
      to: "bess@curationexperts.com",
      subject: "Epigaea test mail",
      body: "Epigaea test mail body"
    )
  end
end
