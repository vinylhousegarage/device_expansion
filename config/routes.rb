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
    post 'login', to: 'system#login'
    delete 'logout', to: 'system#logout'
    delete 'reset_database', to: 'system#reset_database'
  end
end
