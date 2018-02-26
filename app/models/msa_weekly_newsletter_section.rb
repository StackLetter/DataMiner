class MsaWeeklyNewsletterSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

end
