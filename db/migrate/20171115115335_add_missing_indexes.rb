class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :answers, :owner_id
    add_index :questions, :owner_id
    add_index :comments, :owner_id

    add_index :users, :site_id
    #add_index :users, :account_id
    add_index :answers, :question_id
    add_index :questions, :accepted_answer_id
  end
end
