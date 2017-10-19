namespace :html_entities do
  task :translate_all => :environment do

    ActiveRecord::Base.transaction do
      User.find_in_batches do |users|
        users.each do |user|
          user.update(display_name: $html_entities.decode(user.display_name))
        end
      end

      Answer.find_in_batches do |answers|
        answers.each do |answer|
          answer.update(body: $html_entities.decode(answer.body))
        end
      end

      Question.find_in_batches do |questions|
        questions.each do |question|
          question.update(body: $html_entities.decode(question.body))
          question.update(title: $html_entities.decode(question.title))
        end
      end

      Comment.find_in_batches do |comments|
        comments.each do |comment|
          comment.update(body: $html_entities.decode(comment.body))
        end
      end
    end

  end
end
