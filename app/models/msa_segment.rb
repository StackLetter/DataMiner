# == Schema Information
#
# Table name: msa_segments
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  r_identifier :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class MsaSegment < ApplicationRecord

  has_many :users
  has_many :msa_segment_sections, dependent: :destroy, foreign_key: :segment_id
  has_many :msa_sections, through: :msa_segment_sections
  has_many :msa_weekly_newsletter_sections, foreign_key: :segment_id
  has_many :msa_daily_newsletter_sections, foreign_key: :segment_id
  has_many :msa_segment_section_reward_histories, foreign_key: :segment_id

  default_scope -> { order(:r_identifier) }

end
