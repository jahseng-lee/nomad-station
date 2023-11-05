Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    confirmations: "confirmations"
  }

  resource :chat, only: [:show]
  resources :channels, only: [:show, :new, :create] do
    resources :channel_messages, only: [:create, :destroy]
  end
  resources :channel_members, only: [:destroy]
  resource :choose_plan, only: [:show]
  resources :countries, only: [:update] do
    resources :locations, only: [] do
      resources :visas, only: [:new, :create, :edit, :update, :destroy] do
        resources :eligible_countries_for_visas,
          only: [:create, :destroy],
          controller: "visas/eligible_countries_for_visas"

        resources :search_locations,
          only: [:index],
          controller: "visas/search_locations"
      end
    end
  end
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

    resource :visa_information,
      only: [:show, :edit],
      controller: "visa_information"
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
