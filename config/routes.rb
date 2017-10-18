Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  root 'api#index'
  get 'evaluation' => 'evaluation#index'

end
