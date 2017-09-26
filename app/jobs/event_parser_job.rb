class EventParserJob < ApplicationJob
  queue_as :data_mining

  #TODO key, access_token?
  EVENTS_URL = File.join(Api.url, Api.version, 'events?key=U4DMV*8nvpm3EOpvf69Rxw')
  VALID_EVENT_TYPES = ['comment_posted', 'user_created', 'answer_posted', 'question_posted', 'post_edited']

  def perform
    Site.enabled.each do |site|
      page = 1
      page_size = 50
      has_more = true
      questions, answers, comments, users = [], [], [], []
      site_url = "#{EVENTS_URL}((&site=#{site[:api]}&since=15&page=#{page.to_s}&page_size=#{page_size}&access_token=1reG0Ty(sXPe95o6VcIUUQ))"

      loop do
        response = JSON.parse RestClient.get(site_url)

        response['items'].each do |item|
          next unless VALID_EVENT_TYPES.include? item['event_type']
          case item['event_type']
            when 'comment_posted'
              comments << {comment_posted: item['event_id']}
            when 'post_edited'
              # TODO zisit ci sa jedna o question alebo answer
              questions << {post_edited:item['event_id']}
              answers << {post_edited: item['event_id']}
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

      GenericParserJob.perform_later('Comment', comments)
      GenericParserJob.perform_later('User', users)
      GenericParserJob.perform_later('Question', questions)
      GenericParserJob.perform_later('Answer', answers)
    end
  end

end