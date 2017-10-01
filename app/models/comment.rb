class Comment < ApplicationRecord
  include StackApiModelConcern

  belongs_to :answer
  belongs_to :question
end
