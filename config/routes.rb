Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'
  resources :users do
    member do
      post 'login_form'
      post 'login_poster'
    end
    collection do
      post 'login'
      get 'login_poster_redirect'
    end
  end

  resources :posts
end
