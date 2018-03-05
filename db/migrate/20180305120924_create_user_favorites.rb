class CreateUserFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :user_favorites do |t|
      t.integer :site_id, index: true
      t.integer :user_id, index: true
      t.integer :external_id, index: true

      t.timestamps
    end

    add_foreign_key :user_favorites, :users, column: :user_id
    add_foreign_key :user_favorites, :sites, column: :site_id
  end
end
