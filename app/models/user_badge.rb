class UserBadge < ApplicationRecord
  include DoubleLevelStackApiModelConcern

  belongs_to :user
  belongs_to :badge

  validates :badge_id, uniqueness: {scope: :user_id}
end
