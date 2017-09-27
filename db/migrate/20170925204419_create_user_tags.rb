class CreateUserTags < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tags do |t|
      t.references :users, index: true, foreign_key: true, null: false
      t.references :tags, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
