class CreateBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :badges do |t|
      t.integer :external_id, index: true
      t.integer :site_id, index: true
      t.integer :award_count

      t.string :badge_type
      t.string :rank
      t.string :name

      t.text :description # FILTER

      t.timestamps
    end
  end
end
