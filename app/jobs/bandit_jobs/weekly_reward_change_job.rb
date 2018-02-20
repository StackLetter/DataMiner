class BanditJobs::WeeklyRewardChangeJob

  def perform
    segments = MsaSegment.all
    newsletters_from = 7.day.ago
    newsletters_to = 0.days.ago

    newsletters = Newsletter.includes(:evaluation_newsletters, :newsletter_sections).where('created_at >= ?', newsletters_from)
    segments.each do |segment|
      # TODO magic with msa_segment_section_reward
      current_structure = segment.msa_weekly_newsletter_sections
    end
    # TODO magic here
  end

end