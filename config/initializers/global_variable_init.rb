sites = File.read 'config/available_sites.json'
$sites = JSON.parse sites
$sites = $sites.deep_symbolize_keys

api = File.read 'config/api_information.json'
$api = JSON.parse api
$api = $api.deep_symbolize_keys

$error_reporter = ::Rails.application.config.error_reporter.constantize.new