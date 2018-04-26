# == Schema Information
#
# Table name: tags
#
#  id                :integer          not null, primary key
#  site_id           :integer
#  external_id       :integer
#  has_synonyms      :boolean
#  is_moderator_only :boolean
#  is_required       :boolean
#  user_profiled     :boolean          default(FALSE)
#  synonyms          :string           default([]), is an Array
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Tag < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern
  include SiteIdScopedConcern

  has_many :user_tags, dependent: :destroy
  has_many :answer_tags, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # TAGS HAVE NOT ID IN StackExchange API :(
  before_save :setup_external_id

  validates :name, uniqueness: {scope: :site_id}

  def self.find_model_object(api_item_response, site_id = 1)
    return self.find_by(name: api_item_response['name'], site_id: site_id)
  end

  private

  def setup_external_id
    self.external_id = self.id
  end
end
