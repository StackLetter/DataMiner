class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.integer :external_id, index: true
      t.integer :site_id, index: true
      t.integer :up_vote_count # FILTER
      t.integer :down_vote_count # FILTER
      t.integer :owner_id
      t.integer :question_id
      t.integer :score

      t.date :creation_date
      t.date :community_owned_date
      t.date :last_activity_date
      t.date :locked_date

      t.text :body # FILTER

      t.boolean :is_accepted

      t.timestamps
    end

    add_foreign_key :answers, :users, column: :owner_id, index: true, null: true
    add_foreign_key :answers, :questions, column: :question_id, index: true, null: false
  end
end
