Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  root 'api#index'
  
end
