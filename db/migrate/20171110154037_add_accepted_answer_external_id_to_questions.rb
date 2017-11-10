class AddAcceptedAnswerExternalIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :accepted_answer_external_id, :integer, index: true
  end
end
