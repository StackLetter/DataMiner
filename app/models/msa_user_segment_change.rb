# == Schema Information
#
# Table name: msa_user_segment_changes
#
#  id                :integer          not null, primary key
#  from_r_identifier :integer
#  to_r_identifier   :integer
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MsaUserSegmentChange < ApplicationRecord

  belongs_to :user

end
