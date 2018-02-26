class FilterController < ApplicationController

  def popular_unanswered

  end

  def waiting_for_an_answer

  end

  def useful_questions

  end

  def hot_questions

  end

  def answers_you_may_be_interested_in

  end

  def cqa_system_news

  end

  def highly_discussed_questions

  end

  def highly_discussed_answers

  end

  def new_badges

  end

  def prestigious_badges_count_change

  end

  private

  def filter_params
    params.permit(:content)
  end

end