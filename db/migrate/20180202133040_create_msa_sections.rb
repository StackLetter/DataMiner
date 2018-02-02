class CreateMsaSections < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_sections do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
