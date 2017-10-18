class CreateNewsletterSections < ActiveRecord::Migration[5.1]
  def change
    create_table :newsletter_sections do |t|
      t.references :newsletter, index: true, foreign_key: true, null: false

      t.string :name
      t.string :content_type

      t.text :description

      t.integer :content_ids, array: true

      t.timestamps
    end
  end
end
