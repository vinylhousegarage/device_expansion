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
      post 'login'
      delete 'logout'
      delete 'logout_poster'
      post 'reset_database'
    end
  end

  resources :posts
end
