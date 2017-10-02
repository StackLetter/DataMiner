class Comment < ApplicationRecord
  belongs_to :answer, required: false
  belongs_to :question, required: false

  attr_accessor :post_id

  validate :one_foreign_key

  before_save :setup_correct_reference

  def assign_attributes(new_attributes)
    output = super(new_attributes)
    setup_correct_reference
    output
  end

  private

  # solve question_id and answer_id problem
  def self.column_names
    (super << 'post_id').uniq
  end

  include SingleLevelStackApiModelConcern

  def setup_correct_reference
    case self.post_type.try :to_sym
      when :question
        self.question_id = self.post_id
      when :answer
        self.answer_id = self.post_id
      else
        self.question_id = self.post_id
        self.post_type = 'question'
    end
  end

  def one_foreign_key
    errors.add(:answer, :not_specified, message: 'Question or Answer must be specified') if self.post_type == 'question'
    errors.add(:question, :not_specified, message: 'Question or Answer must be specified') if self.post_type == 'answer'
  end

end
