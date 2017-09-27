class GenericParserJob < ApplicationJob
  queue_as :data_mining

  def perform(model, ids = :all, site_id = 1)

    Site.enabled.each do |site|
      chunk = 100 # max 100
      page_size = 100

      ids = model.constantize.all.map { |instance| instance.id } if ids == :all
      ids.each_slice(chunk).each do |chunk|
        chunk = chunk.map { |items| items.values }.flatten if chunk.first.try(:is_a?, Hash)
        page = 1
        has_more = true
        url = File.join(Api.url, Api.version, "#{model.downcase.pluralize}/#{chunk.join(';')}?key=U4DMV*8nvpm3EOpvf69Rxw")
        site_url = "#{url}((&site=#{site[:api]}&order=desc&sort=creation&filter=default&page=#{page.to_s}&page_size=#{page_size.to_s}"

        loop do
          begin
            response = JSON.parse RestClient.get(site_url)
          rescue
          end
          model.constantize.process_json_items response['items'], site_id

          response['has_more'] == false ? has_more = false : page += 1
          sleep(response['backoff'].to_i + 1) if response['backoff']
          break unless has_more

          site_url = "#{url}((&site=#{site[:api]}&order=desc&sort=creation&filter=default&page=#{page.to_s}&page_size=#{page_size.to_s}"
        end
      end
    end

  end
end