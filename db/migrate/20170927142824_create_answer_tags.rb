class CreateAnswerTags < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_tags do |t|
      t.references :answers, index: true, foreign_key: true, null: false
      t.references :tags, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
