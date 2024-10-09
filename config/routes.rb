Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users do
    member do
      post 'login_form'
    end
    collection do
      post 'login'
    end
  end
end
