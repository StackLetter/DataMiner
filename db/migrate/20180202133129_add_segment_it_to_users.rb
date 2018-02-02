class AddSegmentItToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :segment_id, :integer
    add_index :users, :segment_id
  end
end
