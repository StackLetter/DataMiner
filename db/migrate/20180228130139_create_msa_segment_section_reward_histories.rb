class CreateMsaSegmentSectionRewardHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_segment_section_reward_histories do |t|
      t.integer :sections_ids, array: true
      t.float :sections_rewards, array: true
      t.integer :segment_id, index: true
      t.string :newsletter_type

      t.timestamps
    end

    add_foreign_key :msa_segment_section_reward_histories, :msa_segments, column: :segment_id
  end
end
