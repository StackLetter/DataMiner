class UserDataParserJob < ApplicationJob
  queue_as :new_user

  def perform(user_external_id, site_id)
    access_token = available_token
    return unless access_token

    page = 1
    page_size = 100
    has_more = true
    site = Site.enabled.select {|site| site.id == site_id}.first
    query_params = {sort: 'creation'}
    data_urls = []

    data_urls << ['Answer', 'UserAnswer', Api.build_stack_api_url('UserAnswer', [user_external_id],
                                         {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))]
    data_urls << ['Question', 'UserQuestion', Api.build_stack_api_url('UserQuestion', [user_external_id],
                                         {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))]
    data_urls << ['Comment', 'UserComment', Api.build_stack_api_url('UserComment', [user_external_id],
                                         {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))]


    data_urls.each do |data_url|
      model = data_url[0]
      model_url = data_url[1]
      site_url = data_url[2]

      loop do
        begin
          response = JSON.parse RestClient.get(site_url.to_s)
        rescue Exception => e
          ErrorReporter.report(:error, e, "#{klass_error_msg} - #{model}(ids: #{user_external_id}) --- #{site_url.to_s}", response: response)
          raise
        end

        model.constantize.process_json_items response['items'], site_id

        access_token = next_token(access_token) if response['quota_remaining'].to_i <= 2
        return unless access_token
        response['has_more'] == false ? has_more = false : page += 1
        sleep(response['backoff'].to_i + 1) if response['backoff']
        break unless has_more

        site_url = Api.build_stack_api_url(model_url, [user_external_id],
                                           {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))
      end

    end

    UserTagParserJob.perform_later('all', site.id, [user_external_id])
    GenericParserJob.perform_later('UserBadge', [user_external_id], site.id)
  end

end