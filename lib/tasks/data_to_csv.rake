require 'csv'
require 'descriptive_statistics'

namespace :user_segmentation do
  task :user_data_to_csv => :environment do

    CSV.open('tmp/data.csv', 'w') do |writer|
      counter = 0
      potential_counter = 0
      count = User.count
      batch = 1000

      writer << %w(id display_name
                    questions_count answered_questions_count answers_count comments_count user_badges_count
                    question_tags_count
                    answer_tags_count
                    mu_questions mu_answers mu_comments expertise satisfaction)

      User.includes(:questions, :comments, :answers, :user_badges).find_in_batches(batch_size: batch) do |users|
        user_reputations = users.map(&:reputation)
        min_reputation = user_reputations.min
        std_dev_reputation = user_reputations.standard_deviation

        users.select{ |u| !u.without_activity }.each do |user|
          next if user.without_activity
          row = [user.id, user.display_name, #2
                 user.questions.size, user.questions.where(is_answered: true).size, user.answers.size, user.comments.size, user.user_badges.size, #5
                 user.questions.map {|q| q.tags.map(&:name)}.flatten.uniq.size, #1
                 user.answers.map {|a| a.question.tags.map(&:name)}.flatten.uniq.size] #1

          mu_questions = user.questions.size == 0 ? 0 : user.questions.reduce(0.0) {|sum, q| sum + q.score} / user.questions.size

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
          mu_answers = mu_answers / user.answers.size if user.answers.size > 0

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
          mu_comments = mu_comments / user.comments.size if user.comments.size > 0

          answered_questions = user.answers.map(&:question_id).uniq.size
          expertise = answered_questions == 0 || user.questions.size == 0 ? 0 : (answered_questions - user.questions.size).to_f / (Math.sqrt(answered_questions) + Math.sqrt(user.questions.size))

          satisfaction = (user.reputation - min_reputation) / std_dev_reputation

          row << mu_questions
          row << mu_answers
          row << mu_comments
          row << expertise
          row << satisfaction
          writer << row
          counter += 1
        end

        potential_counter += batch
        print("Processed #{counter} of #{count} Users (potential #{potential_counter})... \r")
      end
    end

  end
end
