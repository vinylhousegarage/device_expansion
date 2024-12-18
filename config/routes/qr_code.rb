resources :qr_code, only: [] do
  member do
    get 'login_form'
    get 'qr_code_request'
  end
end
