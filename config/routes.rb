Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    confirmations: "confirmations"
  }

  resource :chat, only: [:show] do
    get :navbar_link
  end
  resources :channels, only: [:show, :new, :create] do
    collection do
      get :joinable
      get :current_user_list
    end

    resources :channel_messages, only: [:index, :create, :destroy]
  end
  resources :channel_members, only: [:create, :destroy] do
    member do
      patch :update_last_active
    end
  end
  resource :choose_plan, only: [:show]
  resources :citizenships, only: [:new, :create, :destroy] do
    collection do
      get :cancel
    end
  end
  namespace :citizenships do
    resources :search_countries, only: [:index]
  end
  resources :countries, only: [] do
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
      get :emergency_info

      patch :generate_description
    end

    resources :banner_images, only: [:create, :update]
    resources :countries, only: [:edit, :update]
    resources :reviews, only: [:index, :show, :new, :create, :edit, :update] do
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
  resources :users, only: [:update] do
    resources :profile_pictures, only: [:create, :update] do
      collection do
        get :upload_modal
      end
    end
  end
  resources :webhooks, only: [:create]

  root to: 'home#index'
end
