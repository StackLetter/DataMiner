class Question < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern
  include OwnerValidationConcern

  belongs_to :owner, class_name: 'User', optional: true
  has_many :answers, dependent: :destroy
  has_one :accepted_answer, class_name: 'Answer', dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  has_many :comments, dependent: :destroy

  after_commit :accepted_answer_exists?

  private

  def accepted_answer_exists?
    GenericParserJob.perform_later('Answer', [self.accepted_answer_id], self.site_id) unless Answer.exists?(external_id: self.accepted_answer_id)
  end
end
