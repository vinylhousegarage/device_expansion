resources :users, only: %i[index show new] do
  resources :posts, only: %i[index show edit update destroy]
end
