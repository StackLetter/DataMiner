class GenericParserJob < ApplicationJob
  queue_as :data_mining

  def perform(model, method_or_ids = 'update_all', site_id = 1, **query_params)
    chunk_size = 100 # max 100
    page_size = 100

    # Update and create at once UNLESS one model query exist in DB
    if method_or_ids.is_a?(Array)
      return if method_or_ids.size == 1 && method_or_ids[0] == nil && model.constantize.exists?(method_or_ids[0].to_i)

      method_or_ids.each_slice(chunk_size).each do |chunk|
        return if chunk.first == nil
        chunk = chunk.map {|items| items.values}.flatten if chunk.first.try(:is_a?, Hash)
        process_model_parsing(model, chunk, page_size, site_id, query_params)
      end
    end

    if method_or_ids == 'update_all'
      ids = model.constantize.all.for_site(site_id).map(&:external_id)
      ids.each_slice(chunk_size).each do |chunk|
        chunk = chunk.map {|items| items.values}.flatten if chunk.first.try(:is_a?, Hash)
        process_model_parsing(model, chunk, page_size, site_id, query_params)
      end
    end

    if method_or_ids == 'new' || method_or_ids == 'all'
      models_since = model.constantize.for_site(site_id).order(created_at: :desc).limit(1).first
      models_since = (models_since && method_or_ids ==  'new') ? models_since.created_at.strftime('%s') : DateTime.new(1970).strftime('%s')

      models = model.underscore.split('_')
      ids = models.size > 1 ? models[0].capitalize.constantize.all.for_site(site_id).map(&:external_id) : nil

      if ids
        ids.each_slice(chunk_size) do |chunk|
          process_model_parsing(model, chunk, page_size, site_id, query_params.merge(fromdate: models_since))
        end
      else
        process_model_parsing(model, nil, page_size, site_id, query_params.merge(fromdate: models_since))
      end
    end
  end

  protected

  def process_model_parsing(model, ids, page_size, site_id, query_params)
    access_token = available_token
    return unless access_token
    page = 1
    has_more = true
    site = Site.enabled.select {|site| site.id == site_id}.first
    site_url = Api.build_stack_api_url(model, ids,
                                       {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))

    loop do
      begin
        response = JSON.parse RestClient.get(site_url.to_s)
      rescue Exception => e
        ErrorReporter.report(:error, e, "#{klass_error_msg} - #{model}(ids: #{ids.to_s}) --- #{site_url.to_s}", response: response)
        raise
      end

      model.constantize.process_json_items response['items'], site_id

      access_token = next_token(access_token) if response['quota_remaining'].to_i <= 2
      return unless access_token
      response['has_more'] == false ? has_more = false : page += 1
      sleep(response['backoff'].to_i + 1) if response['backoff']
      break unless has_more

      site_url = Api.build_stack_api_url(model, ids,
                                         {key: ENV['SE_api_key'], filter: ENV['SE_filter'], pagesize: page_size, page: page, site: site.api, access_token: access_token}.merge(query_params))
    end
  end

end