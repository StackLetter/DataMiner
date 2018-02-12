class CreateMsaWeeklyNewsletterSections < ActiveRecord::Migration[5.1]
  def change
    create_table :msa_weekly_newsletter_sections do |t|

      t.datetime :from
      t.datetime :to
      t.integer :weekly_segment_sections, array: true, default: []
      t.integer :segment_id, index: true

      t.timestamps
    end

    add_foreign_key :msa_weekly_newsletter_sections, :msa_segments, column: :segment_id, null: false
  end
end
