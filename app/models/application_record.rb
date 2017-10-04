class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validates :external_id, uniqueness: true, if: Proc.new {|obj| obj.respond_to?(:external_id) }
end
