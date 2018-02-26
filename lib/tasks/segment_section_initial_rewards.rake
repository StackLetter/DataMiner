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
      end
    end

  end
end

# MsaSegment.includes(msa_segment_sections: :msa_section).all.each {|s| puts(s.name ,s.msa_segment_sections.map {|ss| [ss.reward, ss.msa_section.name].join('-') }.sort.join('  ->  '))}