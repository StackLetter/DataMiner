class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validates :external_id, uniqueness: {scope: :site_id}, if: Proc.new {|obj| obj.respond_to?(:external_id)}

  before_save :translate_html_entities

  protected

  def translate_html_entities

  end

end
