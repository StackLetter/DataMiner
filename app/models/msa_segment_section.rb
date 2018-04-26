# == Schema Information
#
# Table name: msa_segment_sections
#
#  id                       :integer          not null, primary key
#  segment_id               :integer
#  section_id               :integer
#  reward                   :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  daily_newsletters_count  :integer
#  weekly_newsletters_count :integer
#

class MsaSegmentSection < ApplicationRecord

  belongs_to :msa_segment, foreign_key: :segment_id
  belongs_to :msa_section, foreign_key: :section_id

end
