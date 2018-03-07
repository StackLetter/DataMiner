class BanditJobs::RewardsUpdateJob < BanditJobs::BanditJob
  queue_as :evaluation

  def perform(segment_id, section_id, feedback, frequency = 'd')
    segment_section = MsaSegmentSection.includes(:msa_segment, :msa_section).find_by(segment_id: segment_id, section_id: section_id)
    all_segment_sections = segment_section.msa_segment.msa_segment_sections
    #specific_count = frequency == 'd' ? segment_section.daily_newsletters_count : segment_section.weekly_newsletters_count
    specific_count = segment_section.daily_newsletters_count + segment_section.weekly_newsletters_count
    value = segment_section.reward * ((feedback.to_f / 100.0) * (1.0 / specific_count))
debugger
    ActiveRecord::Base.transaction do
    #  segment_section.update! reward: segment_section.reward + value
      other_segments_value = value / (MsaSection.count.to_f - 1.0)

      all_segment_sections.each do |ss|
        next if ss.id == segment_section.id

       # ss.update! reward: ss.reward - other_segments_value
      end
    end
  end

end