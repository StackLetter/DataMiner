class AddCountsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :answers_count, :integer
    add_column :users, :questions_count, :integer
    add_column :users, :user_badges_count, :integer
  end
end
