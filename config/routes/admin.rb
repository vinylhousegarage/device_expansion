namespace :admin do
  resource :session, only: %i[create destroy]

  resource :system, only: [] do
    collection do
      post 'reset_database', to: 'system#reset_database'
      post 'reload_database', to: 'system#reload_database'
    end
  end
end
