class BanditJobs::WeeklyRewardChangeJob < BanditJobs::BanditJob

  def perform
    segments = MsaSegment.includes(:msa_weekly_newsletter_sections, msa_segment_sections: :msa_section).all
    random = Random.new(Random.new_seed)

    segments.each do |segment|
      current_structure = segment.msa_weekly_newsletter_sections.current.first

      sorted_segment_sections = segment.msa_segment_sections.sort_by(&:reward).reverse
      sorted_segment_sections_ids = sorted_segment_sections.map(&:section_id)
      sorted_segment_sections_rewards = sorted_segment_sections.map(&:reward)
      sorted_segment_sections_counts = sorted_segment_sections.map(&:weekly_newsletters_count)

      sections_size = sorted_segment_sections_ids.size
      section_index = 0
      random_section_index = random.rand(sections_size)

      epsylon_greedy_section_ids = (0...sections_size).inject([]) do |buf, _|
        if random.rand > EGreedy::EPSYLON
          section_index += 1 while buf.include?(sorted_segment_sections_ids[section_index])
          buf << sorted_segment_sections_ids[section_index]
          section_index += 1
        else
          random_section_index = random.rand(sections_size) while buf.include?(sorted_segment_sections_ids[random_section_index])
          buf << sorted_segment_sections_ids[random_section_index]
        end

        buf
      end

      puts segment.name, current_structure&.sorted_sections&.join(', ')
      puts 'Epsylon greedy: ', epsylon_greedy_section_ids.join(', ')

      current_structure.update! to: DateTime.now if current_structure
      segment.msa_weekly_newsletter_sections.build(from: DateTime.now, to: 7.days.from_now, sorted_sections: epsylon_greedy_section_ids).save!
      segment.msa_segment_section_reward_histories.build(sections_ids: sorted_segment_sections_ids, sections_rewards: sorted_segment_sections_rewards,
                                                         newsletter_type: 'w', weekly_newsletters_count: sorted_segment_sections_counts).save!
      segment.msa_segment_sections.update_all(weekly_newsletters_count: 0)
    end
  end

end