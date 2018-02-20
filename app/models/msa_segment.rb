class MsaSegment < ApplicationRecord

  has_many :users
  has_many :msa_sections, through: :msa_segment_sections
  has_many :msa_segment_sections, dependent: :destroy
  has_many :msa_weekly_newsletter_sections


end
