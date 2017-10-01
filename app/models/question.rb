class Question < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern

  belongs_to :owner, class_name: 'User'
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
end
