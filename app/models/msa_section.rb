class MsaSection < ApplicationRecord

  has_many :msa_segment_sections, dependent: :destroy, foreign_key: :section_id
  has_many :msa_segments, through: :msa_segment_sections

  SECTION_CONTENT_LIMIT = 5

  default_scope -> { order(:created_at) }

end
