# == Schema Information
#
# Table name: msa_segment_section_reward_histories
#
#  id                       :integer          not null, primary key
#  sections_ids             :integer          is an Array
#  sections_rewards         :float            is an Array
#  segment_id               :integer
#  newsletter_type          :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  daily_newsletters_count  :integer          is an Array
#  weekly_newsletters_count :integer          is an Array
#

class MsaSegmentSectionRewardHistory < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

  default_scope -> { order(created_at: :desc) }

end
