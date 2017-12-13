require 'ladle'

desc 'Start a ladle server'
task :ladle do
  conf_path = Rails.root.join('config')
  ldap_port = Rails.application.config_for(:ldap)['port']

  server = Ladle::Server.new(
    port:  ldap_port,
    quiet: false,
    ldif:  conf_path.join('ldap_seed_users.ldif').to_s
  )

  begin
    server.start
    sleep
  rescue Interrupt
    puts ' Stopping server'
  ensure
    server.stop
  end
end
