resources :users, only: %i[index show new] do
  resources :posts, only: %i[show]
end
