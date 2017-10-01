class Answer < ApplicationRecord
  include StackApiModelConcern

  belongs_to :question
  belongs_to :owner, class: 'User'

  has_many :answer_tags, dependent: :destroy
end
