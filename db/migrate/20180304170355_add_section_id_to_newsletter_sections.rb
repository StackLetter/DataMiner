class AddSectionIdToNewsletterSections < ActiveRecord::Migration[5.1]
  def change
    add_column :newsletter_sections, :section_id, :integer
  end
end
