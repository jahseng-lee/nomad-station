Rails.application.routes.draw do
  devise_for :users
  resources :locations, only: [:show, :edit]
  resources :search_locations, only: [:index]

  root to: 'home#index'
end
