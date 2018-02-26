class PersonalizedRecoController < ApplicationController

  before_action :variables_init

  def index
    head 400 unless @user
    daily = @frequency == 'd'
    limit = daily ? 2 : 5

    # get structure for user segment

    render json: {}
  end

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

  def variables_init
    @user = User.includes(:user_tags, questions: :question_tags).find(recommendation_params[:user_id])

    @frequency = recommendation_params[:frequency]
    @from_date = @frequency == 'd' ? 1.day.ago : 7.day.ago
    @max_from_date = @frequency == 'd' ? 7.day.ago : 21.day.ago

    @duplicates = recommendation_params[:duplicates] ? JSON.parse(URI.decode(recommendation_params[:duplicates])).deep_symbolize_keys : {}

    @tags = @user.user_tags.map(&:tag_id)
    @tags << @user.questions.map {|q| q.question_tags.map(&:tag_id)}
    @tags = @tags.flatten
    @tags = @tags.group_by {|tag| tag}.map {|tag_id, tags| [tags.size, tag_id]}.sort.reverse.map {|n| n[1]} # WARNING - remove map, and setup priority in DB queries
  end

  def recommendation_params
    params.permit(:user_id, :frequency, :duplicates, :domain)
  end

end