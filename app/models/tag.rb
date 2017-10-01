class Tag < ApplicationRecord
  include StackApiModelConcern

  has_many :user_tags, dependent: :destroy
  has_many :answer_tags, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # TAGS HAVE NOT ID IN StackExchange API :(
  before_save :setup_external_id

  private

  def setup_external_id
    self.external_id = self.id
  end
end
