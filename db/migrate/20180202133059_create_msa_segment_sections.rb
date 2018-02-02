class CreateMsaSegmentSections < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_segment_sections do |t|
      t.integer :segment_id, index: true
      t.integer :section_id, index: true
      t.float :reward

      t.timestamps
    end

    add_foreign_key :msa_segment_sections, :msa_segments, column: :segment_id, null: false
    add_foreign_key :msa_segment_sections, :msa_sections, column: :section_id, null: false
  end
end
