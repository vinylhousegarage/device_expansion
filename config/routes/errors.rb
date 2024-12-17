if Rails.env.test?
  get '/internal_server_error_simulation', to: 'application#internal_server_error_simulation'
end

match '*path', to: 'errors#not_found', via: :all
