class CreateMsaDailyNewsletterSections < ActiveRecord::Migration[5.1]

  def change
    create_table :msa_daily_newsletter_sections do |t|

      t.datetime :from
      t.datetime :to
      t.integer :daily_segment_sections, array: true, default: []
      t.integer :segment_id, index: true

      t.timestamps
    end

    add_column :msa_segment_sections, :newsletters_count, :integer
    add_foreign_key :msa_daily_newsletter_sections, :msa_segments, column: :segment_id, null: false
  end

end
