class AddUrlToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :url, :string
  end
end
