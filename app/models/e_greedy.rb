class EGreedy

  EPSYLON = 0.1

  DAILY_SECTION_REWARD = 8
  WEEKLY_SECTION_REWARD = 8

  DAILY_OPEN_REWARD = 4
  WEEKLY_OPEN_REWARD = 4

  def self.get_reward(frequency, type)
    return DAILY_SECTION_REWARD if type == 'section' && frequency == 'd'
    return WEEKLY_SECTION_REWARD if type == 'section' && frequency == 'w'
    return DAILY_OPEN_REWARD if frequency == 'd'
    return WEEKLY_OPEN_REWARD if frequency == 'w'
  end
end