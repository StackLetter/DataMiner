class CreateTableMlsQuestionTopics < ActiveRecord::Migration[5.1]

  def change
    create_table :mls_question_topics do |t|
      t.integer :question_id, index: true
      t.integer :topic_id, index: true
      t.integer :site_id, index: true

      t.float :weight

      t.timestamps
    end

    add_foreign_key :mls_question_topics, :sites, column: :site_id
    add_foreign_key :mls_question_topics, :questions, column: :question_id
  end

end
