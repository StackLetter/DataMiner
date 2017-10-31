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

end
