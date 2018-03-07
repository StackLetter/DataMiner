class MsaDailyNewsletterSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

  MAX_SECTIONS = 2
  BADGES_SECTIONS = 2

  scope :current, -> { where('? >= msa_daily_newsletter_sections.from', DateTime.now).where('? <= msa_daily_newsletter_sections.to', DateTime.now)}

end
