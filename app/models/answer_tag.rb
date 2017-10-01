class AnswerTag < ApplicationRecord
  include StackApiModelConcern

  belongs_to :answer
  belongs_to :tag

  def self.process_json_items(items, site_id)

  end
end
