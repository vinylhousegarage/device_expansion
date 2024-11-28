Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'
  resources :users

  resources :posts

  resources :qr_code do
    member do
      post 'login_form'
      post 'login_poster'
      get 'login_poster_redirect'
    end
    collection do
      delete 'logout_poster'
    end
  end

  namespace :admin do
    resource :session, only: [:create, :destroy]

    resource :system, only: [] do
      collection do
        post 'reset_database', to: 'system#reset_database'
      end
    end
  end
end
