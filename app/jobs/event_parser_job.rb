class EventParserJob < ApplicationJob
  queue_as :data_mining

  #TODO key, access_token?
  VALID_EVENT_TYPES = ['comment_posted', 'user_created', 'answer_posted', 'question_posted', 'post_edited']
  VALID_POST_TYPES = ['question', 'answer']

  def perform
    Site.enabled.each do |site|
      page = 1
      page_size = 100
      has_more = true
      questions, answers, comments, users, posts = [], [], [], [], []
      site_url = Api.build_stack_api_url('Event', nil,
                                         key: 'U4DMV*8nvpm3EOpvf69Rxw((', page_size: page_size, page: page, site: site[:api], since: 15, access_token: '5PbtRbcNjg6Z*7uj7QRH9g))')
      loop do
        begin
          response = JSON.parse RestClient.get(site_url.to_s)
        rescue Exception => e
          ErrorReporter.report(:error, e, "#{klass_error_msg} - Event(ids: all) --- #{site_url.to_s}",  response: response)
          return
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

        site_url = Api.build_stack_api_url('Event', nil,
                                           key: 'U4DMV*8nvpm3EOpvf69Rxw((', page_size: page_size, page: page, site: site[:api], since: 0, access_token: '5PbtRbcNjg6Z*7uj7QRH9g))')
      end

      if posts.size > 0
        posts = process_post_edited(posts, site, page_size)
        answers = answers + posts[:answers]
        questions = questions + posts[:questions]
      end

      GenericParserJob.perform_later('User', users, site[:id])
      GenericParserJob.perform_later('Question', [500], site[:id])
      GenericParserJob.perform_later('Answer', answers, site[:id])
   #   GenericParserJob.perform_later('Comment', comments, site[:id])
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
      site_url = Api.build_stack_api_url('Post', chunk,
                                         key: 'U4DMV*8nvpm3EOpvf69Rxw((', page_size: page_size, page: page, site: site[:api], since: 15, order: :desc, sort: :creation, access_token: '5PbtRbcNjg6Z*7uj7QRH9g))')
      loop do
        begin
          response = JSON.parse RestClient.get(site_url.to_s)
        rescue Exception => e
          ErrorReporter.report(:error, e, "#{klass_error_msg} - Post(ids: #{ids.to_s}) --- #{site_url.to_s}", response: response)
          return to_return
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

        site_url = Api.build_stack_api_url('Post', chunk,
                                           key: 'U4DMV*8nvpm3EOpvf69Rxw((', page_size: page_size, page: page, site: site[:api], since: 15, order: :desc, sort: :creation, access_token: 'VBznJilRMY0g(2mEBWsptw))')
      end
    end

    to_return
  end

end