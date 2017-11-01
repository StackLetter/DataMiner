class EveryDayParserJob < ApplicationJob
  queue_as :data_mining

  def perform
    Site.enabled.each do |site|
      GenericParserJob.perform_later('Badge', 'new', site.id)
      GenericParserJob.perform_later('Tag', 'new', site.id)
      GenericParserJob.perform_later('UserBadge', 'new', site.id)

      users = User.includes(:user_tags).where('account_id IS NOT NULL').where(site_id: site.id)
      users_without_tags = users.select{ |user| user.user_tags.size == 0 }.map(&:id)
      user_with_tags = users.select{ |user| user.user_tags.size > 0 }.map(&:id)
      UserTagParserJob.perform_later('all', site.id, users_without_tags) unless users_without_tags.empty?
      UserTagParserJob.perform_later('new', site.id, user_with_tags) unless user_with_tags.empty?
    end
  end

end