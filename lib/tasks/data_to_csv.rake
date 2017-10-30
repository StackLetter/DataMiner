require 'csv'
require 'descriptive_statistics'

namespace :user_segmentation do
  task :user_data_to_csv => :environment do

    CSV.open('tmp/data.csv', 'w') do |writer|
      counter = 0
      count = User.count

      User.includes(:questions, :comments, :answers, :user_badges).find_in_batches do |users|
        writer << ['id', 'display_name', 'questions_count', 'answered_questions_count', 'answers_count', 'comments_count',
                   'user_badges_count', 'question_tags_count', 'mu_questions', 'mu_answers', 'mu_comments', 'mu_tags', 'expertise', 'satisfaction']

        user_reputations = users.map(&:reputation)
        min_reputation = user_reputations.min
        std_dev_reputation = user_reputations.standard_deviation

        users.each do |user|
          row = [user.id, user.display_name, user.questions.size, user.questions.where(is_answered: true).size, user.answers.size, user.comments.size, user.user_badges.size, user.questions.map {|q| q.tags.map(&:name)}.flatten.uniq.size]

          mu_questions = user.questions.reduce(0.0) {|sum, q| sum + q.score} / user.questions.size

          mu_answers = 0
          user.answers.each do |answer|
            scores = answer.question.answers&.map(&:score)
            mu_answers +=
                if !scores.empty? && scores.uniq != [0]
                  mean = scores.mean
                  std_dev = scores.standard_deviation
                  (answer.score - mean) / std_dev
                else
                  0
                end
          end
          mu_answers = mu_answers / user.answers.count

          mu_comments = 0
          user.comments.each do |comment|
            scores = comment.post.comments&.map(&:score)
            mu_comments +=
                if !scores.empty? && scores.uniq != [0]
                  mean = scores.mean
                  std_dev = scores.standard_deviation
                  (comment.score - mean) / std_dev
                else
                  0
                end
          end
          mu_comments = mu_comments / user.comments.count

          mu_tags = 0
          #TODO tagy?
          expertise = (user.answers.size - user.questions.size).to_f / (Math.sqrt(user.answers.size) + Math.sqrt(user.questions.size))

          satisfaction = (user.reputation - min_reputation) / std_dev_reputation

          row << mu_questions
          row << mu_answers
          row << mu_comments
          row << mu_tags
          row << expertise
          row << satisfaction
          writer << row
          counter += 1
        end

        print("Processed #{counter} of #{count} Users... \r")
      end
    end

  end
end
