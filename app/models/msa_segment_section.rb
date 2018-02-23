class MsaSegmentSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id
  belongs_to :msa_section, foreign_key: :section_id

end
