class EventParserJob < ApplicationJob
  queue_as :data_mining

  #TODO key, access_token?
  EVENTS_URL = File.join(Api.url, Api.version, 'events?key=U4DMV*8nvpm3EOpvf69Rxw')
  VALID_EVENT_TYPES = ['comment_posted', 'user_created', 'answer_posted', 'question_posted', 'post_edited']
  VALID_POST_TYPES = ['question', 'answer']

  def perform
    Site.enabled.each do |site|
      page = 1
      page_size = 100
      has_more = true
      questions, answers, comments, users, posts = [], [], [], [], []
      site_url = "#{EVENTS_URL}((&site=#{site[:api]}&since=15&page=#{page.to_s}&page_size=#{page_size}&access_token=1reG0Ty(sXPe95o6VcIUUQ))"

      loop do
        begin
          response = JSON.parse RestClient.get(site_url)
        rescue
        end
        response['items'].each do |item|
          next unless VALID_EVENT_TYPES.include? item['event_type']
          case item['event_type']
            when 'comment_posted'
              comments << {comment_posted: item['event_id']}
            when 'post_edited'
              posts << item['event_id']
            when 'user_created'
              users << {user_created: item['event_id']}
            when 'answer_posted'
              answers << {answer_posted: item['event_id']}
            when 'question_posted'
              questions << {question_posted: item['event_id']}
            else
              raise Exception, 'Very big fail :('
          end
        end

        response['has_more'] == false ? has_more = false : page += 1
        sleep(response['backoff'].to_i + 1) if response['backoff']
        break unless has_more

        site_url = "#{EVENTS_URL}((&site=#{site[:api]}&since=15&page=#{page.to_s}&page_size=#{page_size}&access_token=1reG0Ty(sXPe95o6VcIUUQ))"
      end

      if posts.size > 0
        posts = process_post_edited(posts, site, page_size)
        answers = answers + posts[:answers]
        questions = questions + posts[:questions]
      end
      GenericParserJob.perform_later('Comment', comments, site[:id])
      GenericParserJob.perform_later('User', users, site[:id])
      GenericParserJob.perform_later('Question', questions, site[:id])
      GenericParserJob.perform_later('Answer', answers, site[:id])
    end
  end

  private

  def process_post_edited(ids, site, page_size)
    chunk = 100
    to_return = {answers: [], questions: []}

    ids.each_slice(chunk).each do |chunk|
      chunk = chunk.map {|items| items.values}.flatten if chunk.first.try(:is_a?, Hash)
      has_more = true
      page = 1
      site_url = "#{File.join(Api.url, Api.version, "posts/#{chunk.join(';')}?key=U4DMV*8nvpm3EOpvf69Rxw")}((&site=#{site[:api]}&page=#{page.to_s}&page_size=#{page_size}&order=desc&sort=creation"

      loop do
        begin
          response = JSON.parse RestClient.get(site_url)
        rescue
        end
        response['items'].each do |item|
          next unless VALID_POST_TYPES.include? item['post_type']
          case item['post_type']
            when 'question'
              to_return[:questions] << {post_edited: item['post_id']}
            when 'answer'
              to_return[:answers] << {post_edited: item['post_id']}
            else
              raise Exception, 'Very big fail :('
          end
        end

        response['has_more'] == false ? has_more = false : page += 1
        sleep(response['backoff'].to_i + 1) if response['backoff']
        break unless has_more
        site_url = "#{File.join(Api.url, Api.version, "posts/#{chunk.join(';')}?key=U4DMV*8nvpm3EOpvf69Rxw")}((&site=#{site[:api]}&page=#{page.to_s}&page_size=#{page_size}&order=desc&sort=creation"
      end
    end

    to_return
  end

end