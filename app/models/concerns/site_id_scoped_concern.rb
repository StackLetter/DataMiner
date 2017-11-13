module SiteIdScopedConcern
  extend ActiveSupport::Concern

  included do

    scope :for_site, -> (id) {where(site_id: id)}

  end

end