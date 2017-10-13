class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :external_id, index: true
      t.integer :site_id, index: true
      t.integer :answer_id, index: true
      t.integer :question_id, index: true
      t.integer :owner_id
      t.integer :score

      t.datetime :creation_date

      t.text :body # FILTER

      t.string :post_type # FILTER

      t.timestamps
    end

    add_foreign_key :comments, :users, column: :owner_id, index: true, null: true
  end
end
