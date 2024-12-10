Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'

  draw :users
  draw :posts
  draw :sessions
  draw :qr_code
  draw :admin
end
