class CreateUserSites < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sites do |t|
      t.integer :site_id
      t.integer :user_id

      t.timestamps
    end

    add_foreign_key :user_sites, :users, column: :user_id, null: false, index: true
  end
end
