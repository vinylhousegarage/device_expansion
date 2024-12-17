if Rails.env.test?
  get '/bad_request_simulation', to: 'application#bad_request_simulation'
  get '/not_found_simulation', to: 'application#not_found_simulation'
  get '/internal_server_error_simulation', to: 'application#internal_server_error_simulation'
end

match '*path', to: 'errors#not_found', via: :all
