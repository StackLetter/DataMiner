class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.integer :accepted_answer_id
      t.integer :bounty_amount
      t.integer :external_id, index: true
      t.integer :site_id, index: true
      t.integer :owner_id
      t.integer :score
      t.integer :up_vote_count # FILTER
      t.integer :down_vote_count # FILTER
      t.integer :view_count

      t.date :bounty_closes_date
      t.date :closed_date
      t.date :creation_date
      t.date :community_owned_date
      t.date :last_activity_date
      t.date :locked_date

      t.text :body # FILTER
      t.string :title

      t.boolean :is_answered

      t.timestamps
    end

    add_foreign_key :questions, :users, column: :owner_id, index: true, null: true
  end
end
