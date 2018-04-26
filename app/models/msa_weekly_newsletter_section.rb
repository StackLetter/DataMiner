# == Schema Information
#
# Table name: msa_weekly_newsletter_sections
#
#  id              :integer          not null, primary key
#  from            :datetime
#  to              :datetime
#  sorted_sections :integer          default([]), is an Array
#  segment_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class MsaWeeklyNewsletterSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

  MAX_SECTIONS = 2
  BADGES_SECTIONS = 2

  scope :current, -> { where('? >= msa_weekly_newsletter_sections.from', DateTime.now).where('? <= msa_weekly_newsletter_sections.to', DateTime.now)}

end
