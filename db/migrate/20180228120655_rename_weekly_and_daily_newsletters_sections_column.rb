class RenameWeeklyAndDailyNewslettersSectionsColumn < ActiveRecord::Migration[5.1]
  def change

    rename_column :msa_daily_newsletter_sections, :daily_segment_sections, :sorted_sections
    rename_column :msa_weekly_newsletter_sections, :weekly_segment_sections, :sorted_sections

  end
end
