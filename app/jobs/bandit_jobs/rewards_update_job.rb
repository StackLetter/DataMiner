  class BanditJobs::RewardsUpdateJob < BanditJobs::BanditJob
  queue_as :evaluation

  def perform(segment_id, section_id, feedback, frequency = 'd', newsletter_created_at = DateTime.now)
    segment_section = MsaSegmentSection.includes(:msa_segment, :msa_section).find_by(segment_id: segment_id, section_id: section_id)
    all_segment_sections = segment_section.msa_segment.msa_segment_sections

    correct_history = MsaSegmentSectionRewardHistory.where(newsletter_type: frequency).where(segment_id: segment_id).where('created_at < ?', newsletter_created_at).first
    history_max = correct_history.sections_rewards.max

    if (newsletter_created_at.to_datetime - 1.day).at_beginning_of_day == DateTime.now.at_beginning_of_day
      specific_count = (frequency == 'd' ? segment_section.daily_newsletters_count : segment_section.weekly_newsletters_count)
    else
      specific_count = (frequency == 'd' ?
                           correct_history.daily_newsletters_count[correct_history.sections_ids.index(section_id)] :
                           correct_history.weekly_newsletters_count[correct_history.sections_ids.index(section_id)])
    end

    if specific_count == 0
      raise Exception.new, "Specific count is 0! => Segment #{segment_id}, Section #{section_id}, NewsletterCreatedAt #{newsletter_created_at}"
    end
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