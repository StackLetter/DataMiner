module ApiTagsIncludedConcern
  extend ActiveSupport::Concern

  included do

    def load_tags_after_parsing
      true
    end

  end
end