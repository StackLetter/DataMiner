class CreateAnswerTags < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_tags do |t|
      t.references :answer, index: true, foreign_key: true, null: false
      t.references :tag, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
