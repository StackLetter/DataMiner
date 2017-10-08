class Site < ApplicationRecord

  scope :enabled, -> { where(enabled: true) }

  validates :config_id, uniqueness: true

end