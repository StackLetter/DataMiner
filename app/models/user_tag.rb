# == Schema Information
#
# Table name: user_tags
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserTag < ApplicationRecord
  include DoubleLevelStackApiModelConcern

  belongs_to :user
  belongs_to :tag

  validates :tag_id, uniqueness: {scope: :user_id}
end
