resource :sessions, only: %i[destroy] do
  member do
    post '/', to: 'sessions#create'
  end
end
