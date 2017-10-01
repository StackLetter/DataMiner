class Answer < ApplicationRecord
  include SingleLevelStackApiModelConcern
  include ApiTagsIncludedConcern

  belongs_to :question
  belongs_to :owner, class_name: 'User'

  has_many :answer_tags, dependent: :destroy
  has_many :tags, through: :answer_tags
end
