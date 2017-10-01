class UserTag < ApplicationRecord
  include StackApiModelConcern

  belongs_to :user
  belongs_to :tag

  def self.process_json_items(items, site_id)

  end
end
