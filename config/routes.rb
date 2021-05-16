Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/complaints/search' , to: 'complaints#search'
  put '/complaints/:id/change_status'  , to: 'complaints#change_status'
  resources :complaints
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
