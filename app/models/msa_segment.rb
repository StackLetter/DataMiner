class MsaSegment < ApplicationRecord

  belongs_to :user
  has_many :msa_sections, through: :msa_segment_sections
  has_many :msa_segment_sections, dependent: :destroy


end
