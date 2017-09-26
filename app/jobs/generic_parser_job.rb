class GenericParserJob < ApplicationJob
  queue_as :data_mining

  def perform(model, ids)

    Site.enabled.each do |site|
      page = 1
      chunk = 100 # max 100

      ids.each_slice(chunk).each do |chunk|
        chunk = chunk.map { |items| items.values }.flatten if chunk.first.try(:is_a?, Hash)

        url = File.join(Api.url, Api.version, "#{model.downcase.pluralize}/#{chunk.join(';')}?key=U4DMV*8nvpm3EOpvf69Rxw")
        site_url = "#{url}((&site=#{site[:api]}&order=desc&sort=creation&filter=default"

        response = JSON.parse RestClient.get(site_url)
        model.constantize.process_json_items response['items']

        sleep(response['backoff'].to_i + 1) if response['backoff']
      end
    end
  end

end