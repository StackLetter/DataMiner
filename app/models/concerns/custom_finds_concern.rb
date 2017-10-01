module CustomFindsConcern
  extend ActiveSupport::Concern

  included do

    def self.find_model_object(api_item_response)
      self.find_by(external_id: api_item_response['external_id'])
    end

  end

end