class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.integer :site_id, index: true
      t.integer :external_id, index: true

      t.boolean :has_synonyms
      t.boolean :is_moderator_only
      t.boolean :is_required

      t.string :synonyms, array: true, default: [] # FILTER
      t.string :name

      t.timestamps
    end
  end
end
