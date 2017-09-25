
if File.exists?('config/sidekiq_cron_jobs.yml')
  Sidekiq::Cron::Job.load_from_hash YAML.load_file('config/sidekiq_cron_jobs.yml')
end