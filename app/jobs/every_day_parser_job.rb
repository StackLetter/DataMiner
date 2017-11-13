class EveryDayParserJob < ApplicationJob
  queue_as :data_mining

  def perform
    Site.enabled.each do |site|
      GenericParserJob.perform_later('Badge', 'new', site.id, {sort: 'name'})
      GenericParserJob.perform_later('Tag', 'new', site.id, {sort: 'name'})

      users_ids = User.for_site(site.id).order('RANDOM()').limit(50000).map(&:external_id)
      users_ids.each_slice(100) {|ids| GenericParserJob.perform_later('UserBadge', ids, site.id)}

      users = User.for_site(site.id).includes(:user_tags).where('account_id IS NOT NULL')
      users_without_tags = users.select {|user| user.user_tags.size == 0}.map(&:external_id)
      user_with_tags = users.select {|user| user.user_tags.size > 0}.map(&:external_id)
      UserTagParserJob.perform_later('all', site.id, users_without_tags) unless users_without_tags.empty?
      UserTagParserJob.perform_later('new', site.id, user_with_tags) unless user_with_tags.empty?
    end
  end

end