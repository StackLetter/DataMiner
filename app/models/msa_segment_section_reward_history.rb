class MsaSegmentSectionRewardHistory < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id

  default_scope -> { order(created_at: :desc) }

end
