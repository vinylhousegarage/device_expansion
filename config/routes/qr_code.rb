resources :qr_code, only: [] do
  member do
    post 'login_form'
    get 'handle_login'
  end
end
