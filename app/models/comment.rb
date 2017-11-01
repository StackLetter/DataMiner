class Comment < ApplicationRecord
  include OwnerValidationConcern

  belongs_to :answer, required: false
  belongs_to :question, required: false
  belongs_to :owner, class_name: 'User', optional: true

  scope :existing, -> { where('comments.removed IS NULL') }

  attr_accessor :post_id, :post

  validate :one_foreign_key

  before_save :setup_correct_reference

  def assign_attributes(new_attributes)
    output = super(new_attributes)
    setup_correct_reference if new_attributes.size > 1
    output
  end

  def self.post_class_name(type)
    case type
      when 'question'
        'Question'
      when 'answer'
        'Answer'
      else
        raise Exception, 'Failed to recognize comment Post class.'
    end
  end

  def post
    return self.question if self.question_id
    return self.answer if self.answer_id
    nil
  end

  protected

  def translate_html_entities
    self.body = $html_entities.decode(self.body)
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
        raise Exception, 'Failed to recognize comment Post.'
    end
  end

  def one_foreign_key
    if self.answer_id.blank? && self.question_id.blank?
      errors.add(:post, :not_specified, message: 'Question or Answer must be specified')
    end
    errors.add(:post, :not_specified, message: 'Question missing') if self.question_id && !Question.exists?(id: self.question_id) && self.post_type == 'question'
    errors.add(:post, :not_specified, message: 'Answer missing') if self.answer_id && !Answer.exists?(id: self.answer_id) && self.post_type == 'answer'
  end

end
