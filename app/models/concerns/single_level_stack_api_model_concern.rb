module SingleLevelStackApiModelConcern
  extend ActiveSupport::Concern

  NOT_VALIDATE_EXTERNAL = ['tag']
  NOT_VALIDATE_SITE = ['user']

  included do
    validates :external_id, presence: true, if: Proc.new { |object| !NOT_VALIDATE_EXTERNAL.include?(object.class.name.downcase) }
    validates :site_id, presence: true, if: Proc.new { |object| !NOT_VALIDATE_SITE.include?(object.class.name.downcase) }

    self::API_ATTRIBUTES = self.column_names.select { |column| !['created_at', 'updated_at', 'id', 'external_id', 'site_id'].include?(column) }

    def self.process_json_items(items, site_id)
      self.transaction do
        items.each do |item|
          data = self::API_ATTRIBUTES.reduce({}) do |hash, key|
            hash[key] = (key.include?('date') && item[key]) ? DateTime.strptime(item[key].to_s, '%s') : item[key]
            hash
          end
          data['external_id'] = item[self.name.downcase + '_id']
          data['site_id'] = site_id

          # two options, some models (Tag) has no ID in StackExchange API
          model = self.find_or_initialize_by(external_id: data['external_id'])
          model = self.find_or_initialize_by(name: data['name']) unless model

          # Inception models and update
          data.merge(owner_id: item['owner']['owner_id']) if model.respond_to?(:owner_id)
          model.assign_attributes(data)
          if model.valid?
            model.update!(data)
          else
            debugger
          end

          if model.respond_to?(:load_tags_after_parsing)
            initialize_tags!(model, item['tags'])
          end
        end
      end
    end

    private

    def initialize_tags!(model, tags)
      db_tags = Tag.where(name: tags)
      model_id = model.class.name.downcase + '_id'

      db_tags.each do |tag|
        model_tag = "#{model.class.name}Tag".constantize.find_or_create_by!(model_id.to_sym => model.id, tag_id: tag.id)
      end
    end

  end
end