class Question < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern

  belongs_to :owner, class_name: 'User'
  has_many :answers, dependent: :destroy
  has_one :accepted_answer, class_name: 'Answer', dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  after_commit :accepted_answer_exists?

  private

  def accepted_answer_exists?
    GenericParserJob.perform_later('Answer', [self.accepted_answer_id], self.site_id) unless Answer.exists?(external_id: self.accepted_answer_id)
  end
end
