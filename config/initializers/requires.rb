require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['sidekiq_login'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
end if Rails.env.production?