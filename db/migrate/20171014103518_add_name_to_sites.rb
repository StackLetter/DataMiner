class AddNameToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :name, :string
  end
end
