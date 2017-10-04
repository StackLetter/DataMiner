module DoubleLevelStackApiModelConcern
  extend ActiveSupport::Concern

  included do

    def self.find_model_object(api_item_response)
      self.find_by(external_id: api_item_response['external_id'])
    end

    def self.process_json_items(items, site_id)
      models = self.name.underscore.split('_')
      base_model = models[0]
      base_model_identifier = base_model + '_id'
      submodel = models[1]
      submodel_identifier = submodel + '_id'
      submodel_class_const = submodel.capitalize.constantize
      base_model_class_const = base_model.capitalize.constantize

      self.transaction do
        items.each do |item|
          submodel_object = submodel_class_const.find_model_object(item[submodel] || item[submodel.pluralize] || item)
          base_model_object = base_model_class_const.find_model_object(item[base_model] || item[submodel.pluralize] || item)

          # Data are not present in the Database, base_model is under higher scope then site --- impossible to detect like a human
          unless submodel_object
            submodel_data = (item[submodel] || item[submodel.pluralize] || item).select { |key, _| submodel_class_const::API_ATTRIBUTES.include? key }
            optional_data = {user_profiled: true}
            optional_data[:external_id] = (item[submodel] || item[submodel.pluralize] || item)[submodel_identifier] unless submodel_class_const::NOT_VALIDATE_EXTERNAL.include? submodel
            optional_data[:site_id] = site_id unless submodel_class_const::NOT_VALIDATE_SITE.include? submodel

            submodel_object = submodel_class_const.new(submodel_data.merge(optional_data))
            submodel_object.save
          end

          if submodel_object && base_model_object
            self.find_or_create_by(submodel_identifier.to_sym => submodel_object.id, base_model_identifier.to_sym => base_model_object.id)
          end
        end
      end
    end

  end
end