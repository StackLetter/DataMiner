class MsaWeeklyNewsletterSection < ApplicationRecord

  belongs_to :msa_segments, foreign_key: :segment_id

end
