class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :api
      t.boolean :enabled
      t.string :name
      t.integer :config_id

      t.timestamps
    end

    add_foreign_key :users, :sites, column: :site_id, index: true, null: false
  end
end
