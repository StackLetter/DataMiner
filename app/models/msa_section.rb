class MsaSection < ApplicationRecord

  has_many :msa_segment_sections, dependent: :destroy, foreign_key: :section_id
  has_many :msa_segments, through: :msa_segment_sections

end
