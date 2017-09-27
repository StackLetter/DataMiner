class EveryDayParserJob < ApplicationJob
  queue_as :data_mining

  def perform
    GenericParserJob.perform_later('Badge')
    GenericParserJob.perform_later('Tag')
    ModelSubcontentParserJob.perform_later('UserBadge')
    ModelSubcontentParserJob.perform_later('UserTag')
  end

end