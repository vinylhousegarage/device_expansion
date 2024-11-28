Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'
  resources :users do
    member do
      post 'login_form'
      post 'login_poster'
      get 'login_poster_redirect'
    end
    collection do
      delete 'logout_poster'
    end
  end

  resources :posts

  namespace :admin do
    resource :session, only: [:create, :destroy] do
      collection do
        post 'login', to: 'sessions#new', as: :sign_in
        delete 'logout', to: 'sessions#destroy', as: :sign_out
      end
    end

    resource :system, only: [] do
      collection do
        delete 'reset_database', to: 'system#reset_database', as: :reset_database
      end
    end
  end
end
