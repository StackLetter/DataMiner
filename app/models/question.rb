class Question < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern
  include OwnerValidationConcern
  include SiteIdScopedConcern

  belongs_to :owner, class_name: 'User', optional: true
  has_many :answers, dependent: :destroy
  has_one :accepted_answer, class_name: 'Answer', dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  has_many :comments, dependent: :destroy

  scope :existing, -> { where('questions.removed IS NULL') }

  after_commit :accepted_answer_exists?

  protected

  def translate_html_entities
    self.body = $html_entities.decode(self.body)
    self.title = $html_entities.decode(self.title)
  end

  private

  def accepted_answer_exists?
    GenericParserJob.perform_later('Answer', [self.accepted_answer_external_id], self.site_id) if self.accepted_answer_external_id &&
        !Answer.exists?(external_id: self.accepted_answer_external_id)
  end
end
