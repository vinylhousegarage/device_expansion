resources :sessions, only: %i[destroy] do
  member do
    post '/', to: 'sessions#create', as: session
  end
end
