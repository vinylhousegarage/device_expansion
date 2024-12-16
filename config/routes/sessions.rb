resources :sessions, only: [] do
  member do
    post 'login_poster'
  end
  collection do
    delete 'logout_poster'
  end
end
