class MsaDailyNewsletterSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

  MAX_SECTIONS = 2
  BADGES_SECTIONS = 2

end
