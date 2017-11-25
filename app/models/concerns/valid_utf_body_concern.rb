module ValidUtfBodyConcern
  extend ActiveSupport::Concern

  included do

    before_save :clear_body_if_invalid

    protected

    def clear_body_if_invalid
      self.body = '' unless self.body.valid_encoding?
    end

  end

end