class User < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern
  include SiteIdScopedConcern

  has_many :user_tags, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :sites, through: :user_sites
  has_many :tags, through: :user_tags
  has_many :badges, through: :user_badges
  has_many :questions, dependent: :destroy, foreign_key: :owner_id
  has_many :answers, dependent: :destroy, foreign_key: :owner_id
  has_many :comments, dependent: :destroy, foreign_key: :owner_id

  scope :existing, -> { where('users.removed IS NULL') }
  scope :stackletter_users, -> { where('users.account_id IS NOT NULL') }

  def self.find_model_object(api_item_response, site_id = 1)
    return self.find_by(external_id: api_item_response['external_id'], site_id: site_id) if api_item_response['external_id']
    return self.find_by(external_id: api_item_response['user_id'], site_id: site_id) if api_item_response['user_id']
    nil
  end

  protected

  def translate_html_entities
    self.display_name = $html_entities.decode(self.display_name)
  end
end
