resources :sessions, only: [] do
  member do
    post 'login_poster'
    get 'login_poster_redirect'
  end
  collection do
    delete 'logout_poster'
  end
end
