namespace :html_entities do
  task :translate_all => :environment do

    count = User.count
    counter = 0
    User.find_in_batches do |users|
      ActiveRecord::Base.transaction do
        users.each do |user|
          user.save
        end
      end
      counter += users.size
      print("Processed #{counter} of #{count} Users... \r")
    end
    puts ''

    count = Answer.count
    counter = 0
    Answer.find_in_batches do |answers|
      ActiveRecord::Base.transaction do
        answers.each do |answer|
          answer.save
        end
      end
      counter += answers.size
      print("Processed #{counter} of #{count} Answers... \r")
    end
    puts ''

    count = Question.count
    counter = 0
    Question.find_in_batches do |questions|
      ActiveRecord::Base.transaction do
        questions.each do |question|
          question.save
        end
      end
      counter += questions.size
      print("Processed #{counter} of #{count} Questions... \r")
    end
    puts ''

    count = Comment.count
    counter = 0
    Comment.find_in_batches do |comments|
      ActiveRecord::Base.transaction do
        comments.each do |comment|
          comment.save
        end
      end
      counter += comments.size
      print("Processed #{counter} of #{count} Comments... \r")
    end
    puts ''

  end
end
