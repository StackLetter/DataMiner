module SingleLevelStackApiModelConcern
  extend ActiveSupport::Concern

  NOT_VALIDATE_EXTERNAL = ['tag']
  NOT_VALIDATE_SITE = ['user']

  def self.name_map(name, type = nil)
    case name
      when 'Owner'
        'User'
      when 'AcceptedAnswer' || 'Accepted'
        'Answer'
      when 'Post'
        Comment.post_class_name(type)
      else
        name
    end
  end

  included do
    validates :external_id, presence: true, if: Proc.new {|object| !NOT_VALIDATE_EXTERNAL.include?(object.class.name.downcase)}
    validates :site_id, presence: true, if: Proc.new {|object| !NOT_VALIDATE_SITE.include?(object.class.name.downcase)}

    self::API_ATTRIBUTES = self.column_names.select {|column| !['created_at', 'updated_at', 'id', 'external_id', 'site_id', 'account_id', 'removed'].include?(column)}

    def self.process_json_items(items, site_id)
      self.transaction do
        items.each do |item|

          data = self::API_ATTRIBUTES.reduce({}) do |hash, key|
            hash[key] = DateTime.strptime(item[key].to_s, '%s') if key.include?('date') && item[key]
            if (key.end_with?('_id') && item[key]) || (key.start_with?('owner') && item['owner'].try(:[], 'user_id'))
              some_instance = SingleLevelStackApiModelConcern.name_map(key.split('_')[-2].camelize, item['post_type']).constantize.find_by(external_id: item[key], site_id: site_id)
              hash[key] = some_instance ? some_instance.id : item[key]
              hash[key] = item['owner'].try(:[], 'user_id') if key.start_with?('owner')
            end

            hash[key] = item[key] unless hash[key]
            hash
          end
          data['external_id'] = item[self.name.downcase + '_id']
          data['site_id'] = site_id

          # two options, some models (Tag) has no ID in StackExchange API
          model = nil
          model = self.where(site_id: site_id).find_or_initialize_by(external_id: data['external_id']) unless self == Tag
          model = self.where(site_id: site_id).find_or_initialize_by(name: data['name']) if self == Tag
          db_owner_id = User.find_by(external_id: item['owner'].try(:[], 'user_id')).try(:id)
          data = data.merge('owner_id': db_owner_id) if model.respond_to?(:owner_id) && db_owner_id
          model.assign_attributes(data)
          if model.valid?
            model.save
            model.update(data)
            self.initialize_tags(model, item['tags'], site_id) if model.respond_to?(:load_tags_after_parsing)
          else
            missing_models = model.errors.details.select {|_, detail| detail.select {|detail| [:not_specified, :blank].include?(detail[:error])}.size > 0}
            if missing_models.size > 0
              missing_models.keys.each do |object, _|
                missing_models_class_name = object.to_s.capitalize
                return if [item[object.to_s + '_id']].blank?
                GenericParserJob.perform_later(SingleLevelStackApiModelConcern.name_map(missing_models_class_name.camelize, item['post_type']), [item[object.to_s + '_id'] || item['owner'].try(:[], 'user_id')], site_id)
              end
              GenericParserJob.perform_later(model.class.name, [model.external_id], site_id)
            end
          end

        end
      end
    end

    private

    def self.initialize_tags(model, tags, site_id = 1)
      db_tags = Tag.for_site(site_id).where(name: tags)
      model_id = model.class.name.downcase + '_id'

      db_tags.each do |tag|
        model_tag = "#{model.class.name}Tag".constantize.find_or_create_by(model_id.to_sym => model.id, tag_id: tag.id)
      end
    end

  end
end