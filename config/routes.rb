require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    resources :currencies, only: [:index, :show]
  end

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
