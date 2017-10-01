class Comment < ApplicationRecord
  include SingleLevelStackApiModelConcern

  belongs_to :answer, validate: false
  belongs_to :question, validate: false

  attr_accessor :post_id

  validate :one_foreign_key

  before_save :setup_correct_reference

  private

  def self.column_names
    super << 'post_id'
  end

  def setup_correct_reference
    case self.post_type.to_sym
      when :question
        self.question_id = self.post_id
      when
      self.answer_id = self.post_id
      else
        raise
    end
  end

  def one_foreign_key
    if !self.answer_id && !self.question_id
      errors.add(:answer, :not_specified, message: 'Question or Answer must be specified')
      errors.add(:question, :not_specified, message: 'Question or Answer must be specified')
    end
  end

end
