class ChangeColumnsInMsaSegmentSections < ActiveRecord::Migration[5.1]
  def change
    rename_column :msa_segment_sections, :newsletters_count, :daily_newsletters_count
    add_column :msa_segment_sections, :weekly_newsletters_count, :integer
  end
end
