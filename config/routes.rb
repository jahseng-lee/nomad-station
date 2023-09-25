Rails.application.routes.draw do
  resources :search_locations, only: [:index]

  root to: 'home#index'
end
