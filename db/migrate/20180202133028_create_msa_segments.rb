class CreateMsaSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_segments do |t|
      t.string :name
      t.text :description
      t.integer :r_identifier

      t.timestamps
    end
  end
end