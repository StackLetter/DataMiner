require 'csv'
class BanditJobs::UserSegmentUpdateJob < BanditJobs::BanditJob

  def perform
    # load R, for each stack letter users predict segment, if changed update changed segment

    CSV.open('tmp/stackletter_users.csv', 'w') do |writer|
      site = 3 # SO
      counter = 0
      potential_counter = 0
      count = User.stackletter_users.count
      batch = 1000

      writer << %w(id display_name
                    questions_count answered_questions_count answers_count comments_count user_badges_count
                    user_tags_count
                    question_tags_count
                    answer_tags_count
                    mu_questions mu_answers mu_comments expertise reputation)

      User.stackletter_users.for_site(site)
          .includes(:questions, :answers, :user_badges)
          .find_in_batches(batch_size: batch) do |users|
        users.each do |user|
          if user.without_activity?
            next
            # TODO assign takychto pouzivatelov rovno do specifickeho segmentu
          end

          row = [user.id, user.display_name.gsub(',', ';'), #2
                 user.questions.count, user.answers.map(&:question_id).uniq.size, user.answers.count, user.comments.size, user.user_badges.map(&:badge_id).uniq.size, #5
                 user.user_tags.map(&:tag_id).uniq.size, #1
                 user.questions.map {|q| q.tags.map(&:name)}.flatten.uniq.size, #1
                 user.answers.map {|a| a.question.tags.map(&:name)}.flatten.uniq.size] #1

          mu_questions = user.questions.count == 0 ? 0 : user.questions.reduce(0.0) {|sum, q| sum + q.score} / user.questions.count

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
          mu_answers = mu_answers / (user.answers.count - zeros) if (user.answers.count - zeros) > 0

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
          mu_comments = mu_comments / (user.comments.size - zeros) if (user.comments.size - zeros) > 0

          answered_questions = user.answers.map(&:question_id).uniq.size
          expertise = answered_questions == 0 || user.questions.count == 0 ? 0 : (answered_questions - user.questions.count).to_f / (Math.sqrt(answered_questions) + Math.sqrt(user.questions.count))

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

    res = system("Rscript #{Rails.root}/app/jobs/bandit_jobs/R/generate_segments_for_users.R")
    ErrorReporter.report(:error, Exception.new, 'Segments of users were not updated!') unless res

    csv = CSV.parse(File.open('tmp/stackletter_users_with_segments.csv'), headers: false)
    csv.each do |row|
      user = User.find(row[0])
      if row[1] != user.msa_segment.r_identifier
        MsaUserSegmentChange.create(from_r_identifier: user.msa_segment.r_identifier, to_r_identifier: row[1], user_id: user.id)
        user.update(segment_changed: true, segment_id: Segment.find_by(r_identifier: row[1]))
      end
    end
  end

end