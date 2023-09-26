Rails.application.routes.draw do
  devise_for :users

  resources :locations, only: [:show, :edit, :update] do
    member do
      patch :generate_description
    end
  end
  resources :search_locations, only: [:index]

  root to: 'home#index'
end
