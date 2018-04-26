# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  api        :string
#  enabled    :boolean
#  name       :string
#  config_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url        :string
#

class Site < ApplicationRecord

  scope :enabled, -> { where(enabled: true) }

  validates :config_id, uniqueness: true

end
