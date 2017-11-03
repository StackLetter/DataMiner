module CustomFindsConcern
  extend ActiveSupport::Concern

  included do

    def self.find_model_object(api_item_response, site_id = 1)
      self.find_by(external_id: api_item_response['external_id'], site_id: site_id)
    end

  end

end