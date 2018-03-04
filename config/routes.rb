Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  root 'api#index'
  get 'evaluation' => 'evaluation#index'

  scope 'trivial_recommendation', constraints: {domain: 'localhost'} do
    get 'structure' => 'trivial_reco#index'
    get 'top_new_questions' => 'trivial_reco#top_new_questions'
    get 'greatest_hits' => 'trivial_reco#greatest_hits'
    get 'answer_these' => 'trivial_reco#answer_these'
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

end
