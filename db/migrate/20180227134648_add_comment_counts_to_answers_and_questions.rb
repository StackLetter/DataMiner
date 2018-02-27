class AddCommentCountsToAnswersAndQuestions < ActiveRecord::Migration[5.1]
  def change

    add_column :questions, :comment_count, :integer
    add_column :answers, :comment_count, :integer

  end
end
