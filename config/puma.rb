#!/usr/bin/env puma

if Rails.env.production?
  application_path = File.expand_path('../', File.dirname(__FILE__))
  directory application_path

  pidfile "#{application_path}/tmp/pids/server.pid"
  state_path "#{application_path}/tmp/pids/server.state"
  stdout_redirect "#{application_path}/log/puma.log", "#{application_path}/log/puma_stderr.log"

  threads_count = ENV.fetch('rails_max_threads') { 5 }.to_i
  threads threads_count, threads_count

  port ENV.fetch('port') { 3000 }
  environment ENV.fetch('RAILS_ENV') { 'development' }

  plugin :tmp_restart
  daemonize true
  activate_control_app
end