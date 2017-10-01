class User < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern

  has_many :user_tags, dependent: :destroy
  has_many :user_sites, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :sites, through: :user_sites
  has_many :tags, through: :user_tags

  attr_accessor :site_id

  after_save :set_up_user_site

  def self.find_model_object(api_item_response)
    return self.find_by(external_id: api_item_response['external_id']) if api_item_response['external_id']
    return self.find_by(external_id: api_item_response['user_id']) if api_item_response['user_id']
    nil
  end

  private

  def set_up_user_site
    unless self.user_sites.map(&:id).include? self.site_id
      UserSite.find_or_create_by(user_id: self.id, site_id: self.site_id)
    end
  end
end
