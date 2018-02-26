class AddContentTypeToMsaSections < ActiveRecord::Migration[5.1]
  def change
    add_column :msa_sections, :content_type, :string
  end
end
