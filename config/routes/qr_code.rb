resources :qr_code, only: [] do
  member do
    get 'login_form'
    get 'handle_login'
  end
end
