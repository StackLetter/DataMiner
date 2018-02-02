class MsaSection < ApplicationRecord

  has_many :msa_segments, through: :msa_segment_sections
  has_many :msa_segment_sections, dependent: :destroy

end
