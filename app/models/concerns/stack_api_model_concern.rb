module StackApiModelConcern
  extend ActiveSupport::Concern

  NOT_VALIDATE_EXTERNAL = ['tag']
  NOT_VALIDATE_SITE = []

  included do
    validates :external_id, presence: true, if: Proc.new { |object| !NOT_VALIDATE_EXTERNAL.include?(object.class.name.downcase) }
    validates :site_id, presence: true, if: Proc.new { |object| !NOT_VALIDATE_SITE.include?(object.class.name.downcase) }

    self::API_ATTRIBUTES = self.column_names.select { |column| !['created_at', 'updated_at', 'id', 'external_id', 'site_id'].include?(column) }

    def self.process_json_items(items, site_id)
      self.transaction do
        items.each do |item|
          data = self::API_ATTRIBUTES.reduce({}) do |hash, key|
            hash[key] = item[key]
            hash
          end
          data['external_id'] = item[self.name.downcase + '_id']
          data['site_id'] = site_id

          # two options, some models (Tag) has no ID in StackExchange API
          model = self.find_or_initialize_by(external_id: data['external_id'])
          model = self.find_or_initialize_by(name: data['name']) unless model
          model.update!(data)
        end
      end
    end

  end
end