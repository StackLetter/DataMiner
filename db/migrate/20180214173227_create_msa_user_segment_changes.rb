class CreateMsaUserSegmentChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_user_segment_changes do |t|
      t.integer :from_r_identifier
      t.integer :to_r_identifier
      t.integer :user_id, index: true

      t.timestamps
    end

    add_foreign_key :msa_user_segment_changes, :users, column: :user_id, null: false
  end
end
