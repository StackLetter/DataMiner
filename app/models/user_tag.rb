class UserTag < ApplicationRecord
  include DoubleLevelStackApiModelConcern

  belongs_to :user
  belongs_to :tag
end
