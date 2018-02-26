class AddColumnsToMsaSections < ActiveRecord::Migration[5.1]
  def change

    add_column :msa_sections, :content_endpoint, :string
    add_column :msa_sections, :filter_endpoint, :string
    add_column :msa_sections, :filter_query, :string

  end
end
