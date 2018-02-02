class AddSegmentChangedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :segment_changed, :boolean
  end
end
