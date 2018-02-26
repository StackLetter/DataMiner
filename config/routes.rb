Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  root 'api#index'
  get 'evaluation' => 'evaluation#index'

  scope 'trivial_recommendation', constraints: {domain: 'localhost'} do
    get 'structure' => 'recommendation#index'
    get 'top_new_questions' => 'recommendation#top_new_questions'
    get 'greatest_hits' => 'recommendation#greatest_hits'
    get 'answer_these' => 'recommendation#answer_these'
  end

  scope 'recommendation', constraints: {domain: 'localhost'} do
    get 'structure' => 'personalized_reco#index'

    get 'popular_unanswered' => 'personalized_reco#popular_unanswered'
    get 'waiting_for_an_answer' => 'personalized_reco#waiting_for_an_answer'
    get 'useful_questions' => 'personalized_reco#useful_questions'
    get 'hot_questions' => 'personalized_reco#hot_questions'
    get 'answers_you_may_be_interested_in'  => 'personalized_reco#answers_you_may_be_interested_in'
    get 'cqa_system_news' => 'personalized_reco#cqa_system_news'
    get 'highly_discussed_questions' => 'personalized_reco#highly_discussed_questions'
    get 'highly_discussed_answers' => 'personalized_reco#highly_discussed_answers'
    get 'new_badges' => 'personalized_reco#new_badges'
    get 'prestigious_badges_count_change' => 'personalized_reco#prestigious_badges_count_change'
  end

  scope 'filter', constraints: {domain: 'localhost'} do
    get 'popular_unanswered' => 'filter#popular_unanswered'
    get 'waiting_for_an_answer' => 'filter#waiting_for_an_answer'
    get 'useful_questions' => 'filter#useful_questions'
    get 'hot_questions' => 'filter#hot_questions'
    get 'answers_you_may_be_interested_in' => 'filter#answers_you_may_be_interested_in'
    get 'cqa_system_news' => 'filter#cqa_system_news'
    get 'highly_discussed_questions' => 'filter#highly_discussed_questions'
    get 'highly_discussed_answers' => 'filter#highly_discussed_answers'
    get 'new_badges' => 'filter#new_badges'
    get 'prestigious_badges_count_change' => 'filter#prestigious_badges_count_change'
  end

end
