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
  #resource :choose_plan, only: [:show]
  resources :issues, only: [:index, :create, :update]
  resources :locations, only: [:show, :edit, :update, :destroy] do
    member do
      get :upload_banner_image_modal
      get :emergency_info

      patch :generate_description
    end

    resources :banner_images, only: [:create, :update]
    resources :countries, only: [:edit, :update]
    resources :reviews, only: [:index, :show, :new, :create, :edit, :update]
    resource :visa_information, only: [:show, :edit, :update] do
      collection do
        get :content
        get :report_issue_modal
      end
    end
  end
  resource :profile, only: [:show] do
    collection do
      get :overview
      get :reviews
    end
  end
  resources :search_locations, only: [:index]
  resources :subscriptions, only: [] do
    collection do
      get :profile_section
    end
  end
  resources :users, only: [:show, :update] do
    resources :locations do
      # Citizenship actions specifically on the VisaInformation#show page
      resources(
        :citizenships,
        only: [:create],
        controller: "locations/citizenships"
      ) do
        collection do
          get :modal_new
        end
      end
    end

    # More general citizenships controller used for the profile page
    # actions
    resources :citizenships, only: [:create, :update] do
      collection do
        get :modal
      end
    end

    resources :profile_pictures, only: [:create, :update] do
      collection do
        get :upload_modal
      end
    end
  end
  resources :webhooks, only: [:create]

  root to: 'home#index'
end
