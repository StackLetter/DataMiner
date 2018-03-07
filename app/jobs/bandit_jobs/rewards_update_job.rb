  class BanditJobs::RewardsUpdateJob < BanditJobs::BanditJob
  queue_as :evaluation

  def perform(segment_id, section_id, feedback, frequency = 'd')
    segment_section = MsaSegmentSection.includes(:msa_segment, :msa_section).find_by(segment_id: segment_id, section_id: section_id)
    all_segment_sections = segment_section.msa_segment.msa_segment_sections

    history_max = MsaSegmentSectionRewardHistory.where(newsletter_type: frequency).where(segment_id: segment_id).first.sections_rewards.max
    specific_count = frequency == 'd' ? segment_section.daily_newsletters_count : segment_section.weekly_newsletters_count
    value = history_max * ((feedback.to_f / 100.0) * (1 / Math.log2(specific_count.to_f + 1)))

    ActiveRecord::Base.transaction do
      segment_section.update! reward: segment_section.reward + value
      other_segments_value = value / (MsaSection.count.to_f - 1.0)

      all_segment_sections.each do |ss|
        next if ss.id == segment_section.id

        ss.update! reward: ss.reward - other_segments_value
      end
    end
  end

end