# == Schema Information
#
# Table name: badges
#
#  id            :integer          not null, primary key
#  external_id   :integer
#  site_id       :integer
#  award_count   :integer
#  user_profiled :boolean          default(FALSE)
#  badge_type    :string
#  rank          :string
#  name          :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Badge < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern
  include SiteIdScopedConcern

  has_many :user_badges, dependent: :destroy

  def self.find_model_object(api_item_response, site_id = 1)
    return self.find_by(external_id: api_item_response['external_id'], site_id: site_id) if api_item_response['external_id']
    return self.find_by(external_id: api_item_response['badge_id'], site_id: site_id) if api_item_response['badge_id']
    nil
  end

  def self.has_new_badge?(from, to, site_id)
    self.new_badges(from, to, site_id).any?
  end

  def self.new_badges(from, to, site_id)
    self.where('created_at >= ?', from).where('created_at <= ?', to).where(site_id: site_id)
  end
end
