Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    confirmations: "confirmations"
  }

  resource :chat, only: [:show]
  resource :choose_plan, only: [:show]
  resources :locations, only: [:show, :edit, :update] do
    member do
      get :upload_banner_image_modal

      patch :generate_description
    end

    resources :banner_images, only: [:create, :update]

    resources :reviews, only: [:show, :new, :create, :edit, :update] do
      collection do
        post :generate_review
      end
    end

    resource :visa_information, only: [:show], controller: "visa_information"
  end
  resource :profile, only: [:show]
  resources :search_locations, only: [:index]
  resources :subscriptions, only: [] do
    collection do
      post :manage
    end
  end
  resources :users, only: [:update]
  resources :webhooks, only: [:create]

  root to: 'home#index'
end
