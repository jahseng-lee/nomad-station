Rails.application.routes.draw do
  devise_for :users

  resources :locations, only: [:show, :edit, :update] do
    member do
      patch :generate_description
    end

    resources :reviews, only: [:show, :new, :create, :edit, :update] do
      collection do
        post :generate_review
      end
    end
  end
  resources :search_locations, only: [:index]

  root to: 'home#index'
end
