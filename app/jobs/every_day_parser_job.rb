class EveryDayParserJob < ApplicationJob
  queue_as :data_mining

  def perform
    Site.enabled.each do |site|
      GenericParserJob.perform_later('Badge', 'new', site.id)
      GenericParserJob.perform_later('Tag', 'new', site.id)
      GenericParserJob.perform_later('UserBadge', 'new', site.id)
  #    GenericParserJob.perform_later('UserTag', 'all', site.id)
  #    GenericParserJob.perform_later('Badge', 'update_all', site.id)
    end
  end

end