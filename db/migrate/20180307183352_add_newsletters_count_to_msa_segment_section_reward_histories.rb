class AddNewslettersCountToMsaSegmentSectionRewardHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :msa_segment_section_reward_histories, :daily_newsletters_count, :integer, array: true
    add_column :msa_segment_section_reward_histories, :weekly_newsletters_count, :integer, array: true
  end
end
