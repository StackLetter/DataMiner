class EveryDayParserJob < ApplicationJob  queue_as :data_mining

  queue_as :data_mining

  def perform
    puts 'I work'
  end

end