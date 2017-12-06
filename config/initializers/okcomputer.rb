require 'honeybadger'
require 'net/smtp'

# Check to ensure we can connect to SMTP as expected. We are writing our own because the
# ActionMailer test bundled with okcomputer doesn't seem to work for Amazon SES.
class SmtpCheck < OkComputer::Check
  def check
    smtp = Net::SMTP.new ENV['ACTION_MAILER_SMTP_ADDRESS'], ENV['ACTION_MAILER_PORT']
    smtp.enable_starttls
    smtp.start('curationexperts.com', ENV['ACTION_MAILER_USER_NAME'], ENV['ACTION_MAILER_PASSWORD'], :plain) do
      mark_message "SMTP connection working"
    end
  rescue => exception
    Honeybadger.notify(exception)
    mark_failure
    mark_message "Cannot connect to SMTP"
  end
end

# Monitor sidekiq queue latency. Queue latency is the difference between when the
# oldest job was pushed onto the queue versus the current time. This code will
# check that jobs don't spend more than 360 seconds enqueued. We'll need to adjust
# this as we figure out what expected parameters are.
# See https://github.com/mperham/sidekiq/wiki/Monitoring#monitoring-queue-latency for general pattern.
OkComputer::Registry.register "handle_sidekiq_queue_latency", OkComputer::SidekiqLatencyCheck.new('ingest', 360)
OkComputer::Registry.register "batch_sidekiq_queue_latency", OkComputer::SidekiqLatencyCheck.new('batch', 360)
OkComputer::Registry.register "handle_sidekiq_queue_latency", OkComputer::SidekiqLatencyCheck.new('handle', 360)
OkComputer::Registry.register "default_sidekiq_queue_latency", OkComputer::SidekiqLatencyCheck.new('default', 360)

OkComputer::Registry.register "smtp", SmtpCheck.new
