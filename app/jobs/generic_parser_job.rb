class GenericParserJob < ApplicationJob
  queue_as :data_mining

  def perform(model, method_or_ids = :update_all, site_id = 1)
    chunk_size = 100 # max 100
    page_size = 100

    if method_or_ids == :update_all || method_or_ids.is_a?(Array)
      ids = model.constantize.all.map { |instance| instance.id }
      ids.each_slice(chunk_size).each do |chunk|
        chunk = chunk.map { |items| items.values }.flatten if chunk.first.try(:is_a?, Hash)
        process_model_parsing(model, chunk, page_size, site_id)
      end
    end

    if method_or_ids == :new
      process_model_parsing(model, nil, page_size, site_id)
    end
  end

  private

  def process_model_parsing(model, ids, page_size, site_id)
    page = 1
    has_more = true
    site = Site.enabled.select { |site| site[:id] == site_id }
    site_url = Api.build_stack_api_url(model, ids,
                                       key: 'U4DMV*8nvpm3EOpvf69Rxw', page_size: page_size, page: page, site: site[:api], order: :desc, sort: :creation)

    loop do
      begin
        response = JSON.parse RestClient.get(site_url.to_s)
      rescue Exception => e
        Rollbar.error("#{klass_error_msg} - #{model}(ids: #{ids.to_s}) --- #{site_url.to_s}")
        return
      end
      model.constantize.process_json_items response['items'], site_id

      response['has_more'] == false ? has_more = false : page += 1
      sleep(response['backoff'].to_i + 1) if response['backoff']
      break unless has_more

      site_url = Api.build_stack_api_url(model, ids,
                                         key: '', page_size: page_size, page: page, site: site[:api], order: :desc, sort: :creation)
    end
  end

end