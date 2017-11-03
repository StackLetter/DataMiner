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
end
