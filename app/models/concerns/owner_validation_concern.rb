module OwnerValidationConcern
  extend ActiveSupport::Concern

  included do

    validate  :owner_persistence

    private

    def owner_persistence
      if self.owner_id && !User.exists?(self.owner_id)
        errors.add(:owner, :not_specified, message: 'Owner missing in database')
      end
    end

  end

end