require 'csv'
require 'descriptive_statistics'

namespace :user_segmentation do
  task :user_data_to_csv => :environment do

    CSV.open('tmp/data_so.csv', 'w') do |writer|
      site = 3
      counter = 0
      potential_counter = 0
      count = User.count
      batch = 1000

      writer << %w(id display_name
                    questions_count answered_questions_count answers_count comments_count user_badges_count
                    user_tags_count
                    question_tags_count
                    answer_tags_count
                    mu_questions mu_answers mu_comments expertise satisfaction)

      User.for_site(site)
          .includes(:questions, :answers, :user_badges)
          .find_in_batches(batch_size: batch) do |users|
        users.each do |user|
          next if user.without_activity? || counter > 250000

          row = [user.id, user.display_name.gsub(',', ';'), #2
                 user.questions_count, user.questions.where(is_answered: true).size, user.answers_count, user.comments.size, user.user_badges.map(&:badge_id).uniq.size, #5
                 user.user_tags.map(&:tag_id).uniq.size, #1
                 user.questions.map {|q| q.tags.map(&:name)}.flatten.uniq.size, #1
                 user.answers.map {|a| a.question.tags.map(&:name)}.flatten.uniq.size] #1

          mu_questions = user.questions_count == 0 ? 0 : user.questions.reduce(0.0) {|sum, q| sum + q.score} / user.questions_count

          mu_answers = 0
          zeros = 0
          user.answers.each do |answer|
            scores = answer.question.answers&.map(&:score)
            mu_answers +=
                if !scores.empty? && scores.uniq != [0]
                  mean = scores.mean
                  std_dev = scores.standard_deviation
                  result = (answer.score - mean) / std_dev
                  (result.nan? ? 0 : result)
                else
                  zeros += 1
                  0
                end
          end
          mu_answers = mu_answers / (user.answers_count - zeros) if (user.answers_count - zeros) > 0

          mu_comments = 0
          zeros = 0
          user.comments.each do |comment|
            scores = comment.post.comments&.map(&:score)
            mu_comments +=
                if !scores.empty? && scores.uniq != [0]
                  mean = scores.mean
                  std_dev = scores.standard_deviation
                  result = (comment.score - mean) / std_dev
                  (result.nan? ? 0 : result)
                else
                  zeros += 1
                  0
                end
          end
          mu_comments = mu_comments / (user.comments.size - zeros) if  (user.comments.size - zeros) > 0

          answered_questions = user.answers.map(&:question_id).uniq.size
          expertise = answered_questions == 0 || user.questions_count == 0 ? 0 : (answered_questions - user.questions_count).to_f / (Math.sqrt(answered_questions) + Math.sqrt(user.questions_count))

          row << mu_questions
          row << mu_answers
          row << mu_comments
          row << expertise
          row << user.reputation
          writer << row
          counter += 1
        end

        potential_counter += batch
        print("Processed #{counter} of #{count} Users (potential #{potential_counter})... \r")
      end
    end

  end

  task :counts_to_db => :environment do
    counter = 0
    site = 3
    count = User.for_site(site).count

    User.for_site(site).find_in_batches do |users|
      User.transaction do
        users.each do |user|
          user.update(comments_count: user.comments.count, user_badges_count: user.user_badges.count, questions_count: user.questions.count, answers_count: user.answers.count)

          counter += 1
          print("Processed #{counter} of #{count} Users... \r")
        end
      end
    end

  end
end
