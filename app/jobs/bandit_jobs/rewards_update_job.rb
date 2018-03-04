class BanditJobs::RewardsUpdateJob < BanditJobs::BanditJob
  queue_as :evaluation

  def perform(segment_id, section_id, feedback)
    segments_count = MsaSegment.count

    segment_section = MsaSegmentSection.includes(:msa_segment, :msa_section).find_by(segment_id: segment_id, section_id: section_id)
    value = feedback.to_f / (segment_section.newsletters_count * segments_count.to_f)

    ActiveRecord::Base.transaction do
      segment_section.update! reward: segment_section.reward + value
      other_segments_value = value / (segments_count.to_f - 1.0)

      segment_section.msa_segment.msa_segment_sections.each do |ss|
        next if ss.id == segment_section.id

        ss.update! reward: ss.reward - other_segments_value
      end
    end
  end

end