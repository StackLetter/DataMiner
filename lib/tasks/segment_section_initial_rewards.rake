namespace :initial_model do
  task :initial_reward => :environment do

    MsaSegment.all.each do |segment|
      MsaSegment.transaction do
        MsaSection.all.each do |section|
          current_segment_section = MsaSegmentSection.find_or_initialize_by(segment_id: segment.id, section_id: section.id)

          print("Add reward for segment '#{segment.name}' and section '#{section.name} (current reward is #{current_segment_section.persisted? ? current_segment_section.reward : 'NIL'}): ")
          reward = STDIN.gets.strip
          begin
            current_segment_section.reward = reward.to_f
            save_state = current_segment_section.save
          rescue Exception => e
            puts e.message
          ensure
            if save_state
              puts "MsaSegmentSection with id #{current_segment_section.id} was updated."
            else
              puts 'ERROR'
              puts current_segment_section.errors.full_messages
              raise Exception.new "Initial MsaSection rewards for MsaSegment with id #{segment.id} were not updated."
            end
          end

        end
        MsaSegmentSection.all.update_all daily_newsletters_count: 0
        MsaSegmentSection.all.update_all weekly_newsletters_count: 0
      end
    end

  end

  task :load_initial_rewards => :environment do
    ActiveRecord::Base.transaction do
      MsaSegment.all.each do |segment|
        initial_model = segment.msa_segment_section_reward_histories.last

        segment.msa_segment_sections.each do |segment_section|
          index_of_reward = initial_model.sections_ids.find_index(segment_section.section_id)
          segment_section.update!(reward: initial_model.sections_rewards[index_of_reward])
        end
      end
    end
  end

  task :initial_week_structure => :environment do
    MsaSegmentSection.all.update_all daily_newsletters_count: 0
    MsaSegmentSection.all.update_all weekly_newsletters_count: 0

    MsaSegment.includes(:msa_weekly_newsletter_sections, msa_segment_sections: :msa_section).all.each do |segment|
      sorted_segment_sections = segment.msa_segment_sections.sort_by(&:reward).reverse
      sorted_segment_sections_ids = sorted_segment_sections.map(&:section_id)
      sorted_segment_sections_rewards = sorted_segment_sections.map(&:reward)

      segment.msa_weekly_newsletter_sections.destroy_all
      segment.msa_segment_section_reward_histories.destroy_all

      segment.msa_weekly_newsletter_sections.build(from: DateTime.now, to: 7.days.from_now, sorted_sections: sorted_segment_sections_ids).save
      segment.msa_segment_section_reward_histories.build(sections_ids: sorted_segment_sections_ids, sections_rewards: sorted_segment_sections_rewards, newsletter_type: 'w').save
    end

    MsaSegment.includes(:msa_daily_newsletter_sections, msa_segment_sections: :msa_section).all.each do |segment|
      sorted_segment_sections = segment.msa_segment_sections.sort_by(&:reward).reverse
      sorted_segment_sections_ids = sorted_segment_sections.map(&:section_id)
      sorted_segment_sections_rewards = sorted_segment_sections.map(&:reward)

      segment.msa_daily_newsletter_sections.destroy_all

      segment.msa_daily_newsletter_sections.build(from: DateTime.now, to: 1.days.from_now, sorted_sections: sorted_segment_sections_ids).save
      segment.msa_segment_section_reward_histories.build(sections_ids: sorted_segment_sections_ids, sections_rewards: sorted_segment_sections_rewards, newsletter_type: 'd').save
    end

  end
end

# MsaSegment.includes(msa_segment_sections: :msa_section).all.each {|s| puts(s.name ,s.msa_segment_sections.map {|ss| [ss.reward, ss.msa_section.name].join('-') }.sort.reverse.join('  ->  '), '')}