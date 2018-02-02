class AddSegmentIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :segment_id, :integer
    add_index :users, :segment_id

    add_foreign_key :users,  :msa_segments, column: :segment_id, null: false
  end
end
