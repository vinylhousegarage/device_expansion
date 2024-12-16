resources :sessions, only: [destroy] do
  member do
    post '/', to: 'sessions#create', as: session
  end
end
