# == Schema Information
#
# Table name: msa_sections
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  content_endpoint :string
#  filter_endpoint  :string
#  filter_query     :string
#  content_type     :string
#

class MsaSection < ApplicationRecord

  has_many :msa_segment_sections, dependent: :destroy, foreign_key: :section_id
  has_many :msa_segments, through: :msa_segment_sections

  SECTION_CONTENT_LIMIT = 5

  default_scope -> { order(:created_at) }

end
