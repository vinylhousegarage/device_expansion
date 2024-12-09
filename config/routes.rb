Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'

  resources :users

  resources :posts

  resources :sessions do
    member do
      post 'login_poster'
      get 'login_poster_redirect'
    end
    collection do
      delete 'logout_poster'
    end
  end

  resources :qr_code do
    member do
      post 'login_form'
    end
  end

  namespace :admin do
    resource :session, only: %i[create destroy]

    resource :system, only: [] do
      collection do
        post 'reset_database', to: 'system#reset_database'
      end
    end

    resources :users, only: [] do
      resources :posts, only: [:index, :show, :edit, :update, :destroy], controller: 'system'
    end
  end
end
