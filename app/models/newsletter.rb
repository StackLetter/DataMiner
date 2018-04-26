# == Schema Information
#
# Table name: newsletters
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Newsletter < ApplicationRecord

  belongs_to :user
  has_many :newsletter_sections
  has_many :evaluation_newsletters

end
