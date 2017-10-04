class Answer < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern

  belongs_to :question
  belongs_to :owner, class_name: 'User'
  has_many :comments, dependent: :destroy

  has_many :answer_tags, dependent: :destroy
  has_many :tags, through: :answer_tags

  before_save :update_question

  private

  def update_question
    if self.is_accepted
      self.question.update(accepted_answer_id: self.id)
    end
  end

end
