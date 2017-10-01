class UserBadge < ApplicationRecord
  include DoubleLevelStackApiModelConcern

  belongs_to :user
  belongs_to :badge
end
