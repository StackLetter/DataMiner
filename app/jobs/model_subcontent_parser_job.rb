class ModelSubcontentParserJob < ApplicationJob
  queue_as :data_mining

  def perform(model, ids = :all, site_id = 1)
    api = model.underscore.split('_').map(&:pluralize)

    Site.enabled.each do |site|
      chunk = 100 # max 100

      # base model ids, f.e.: users
      ids = api[0].capitalize.singularize.constantize.all.map {|instance| instance.id} if ids == :all
      ids.each_slice(chunk).each do |chunk|
        chunk = chunk.map {|items| items.values}.flatten if chunk.first.try(:is_a?, Hash)
        page = 1
        has_more = true
        url = File.join(Api.url, Api.version, "#{api[0]}/#{chunk.join(';')}/#{api[1]}?key=U4DMV*8nvpm3EOpvf69Rxw")
        site_url = "#{url}((&site=#{site[:api]}&order=desc&filter=default&page=#{page.to_s}"

        loop do
          begin
            response = JSON.parse RestClient.get(site_url)
          rescue Exception => e
            Rollbar.error("#{klass_error_msg} - #{model}(ids: #{ids.to_s}) --- #{site_url}")
            return
          end
          model.constantize.process_json_items response['items'], site_id

          response['has_more'] == false ? has_more = false : page += 1
          sleep(response['backoff'].to_i + 1) if response['backoff']
          break unless has_more

          site_url = "#{url}((&site=#{site[:api]}&order=desc&filter=default&page=#{page.to_s}"
        end
      end
    end

  end
end