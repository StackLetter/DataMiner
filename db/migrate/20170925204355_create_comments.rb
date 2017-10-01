class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :external_id, index: true
      t.integer :site_id, index: true
      t.integer :answer_id
      t.integer :question_id
      t.integer :score

      t.date :creation_date

      t.text :body # FILTER

      t.string :post_type # FILTER

      t.timestamps
    end

    add_foreign_key :comments, :questions, columnn: :question_id, index: true
    add_foreign_key :comments, :answers, columnn: :answer_id, index: true
  end
end
