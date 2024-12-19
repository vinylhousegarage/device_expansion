resources :sessions, only: [] do
  member do
    post 'login'
  end
  collection do
    delete 'logout'
  end
end
