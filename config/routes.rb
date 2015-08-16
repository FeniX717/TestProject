Rails.application.routes.draw do
  root to: "sessions#new"
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get "/auth/failure", to: "sessions#failure", :as => "failure"
  get "/logout", to: "sessions#destroy", :as => "logout"
  resources :emails, only: [:show, :update]
end
