# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sites = File.read 'config/available_sites.json'
sites = JSON.parse sites

Site.transaction do
  sites.each do |_key, value|

    Site.create(api: value['api'], enabled: value['enabled'], config_id: value['id'], name: value['name'])

  end
end