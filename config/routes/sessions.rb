resource :sessions, only: %i[destroy]

post '/sessions/:id', to: 'sessions#create', as: :create_session
