class Answer < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern
  include OwnerValidationConcern
  include SiteIdScopedConcern
  include ValidUtfBodyConcern

  belongs_to :question
  belongs_to :owner, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  has_many :answer_tags, dependent: :destroy
  has_many :tags, through: :answer_tags

  before_save :update_question

  scope :existing, -> { where('answers.removed IS NULL') }

  protected

  def translate_html_entities
    self.body = $html_entities.decode(self.body)
  end

  private

  def update_question
    if self.is_accepted
      self.question.update(accepted_answer_id: self.id)
    end
  end

end
