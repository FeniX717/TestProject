Rails.application.routes.draw do
  root to: "sessions#new"
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get "/auth/failure", to: "sessions#failure", :as => "failure"
  get "/logout", to: "sessions#destroy", :as => "logout"
  resources :emails, only: [:show, :update]
end


