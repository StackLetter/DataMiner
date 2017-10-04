class Tag < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include CustomFindsConcern

  has_many :user_tags, dependent: :destroy
  has_many :answer_tags, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # TAGS HAVE NOT ID IN StackExchange API :(
  before_save :setup_external_id

  validates :name, uniqueness: true

  def self.find_model_object(api_item_response)
    return self.find_by(name: api_item_response['name'])
    nil
  end

  private

  def setup_external_id
    self.external_id = self.id
  end
end
