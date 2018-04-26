# == Schema Information
#
# Table name: user_badges
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  badge_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserBadge < ApplicationRecord
  include DoubleLevelStackApiModelConcern

  belongs_to :user
  belongs_to :badge

  validates :badge_id, uniqueness: {scope: :user_id}
end
