class Question < ApplicationRecord
  include StackApiModelConcern

  belongs_to :owner, class: 'User'
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
end
