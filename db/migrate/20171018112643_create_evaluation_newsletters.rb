class CreateEvaluationNewsletters < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluation_newsletters do |t|
      t.references :newsletter, index: true, foreign_key: true, null: false

      t.integer :response_counter

      t.string :content_type
      t.string :content_detail
      t.string :user_response_type
      t.string :user_response_detail
      t.string :event_identifier

      t.datetime :action_datetime

      t.timestamps
    end
  end
end
