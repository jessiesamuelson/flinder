Rails.application.routes.draw do

  get '/users/twitterlogin' => :twitter_login, controller: :users

  get '/users/twitter_callback' => :twitter_callback, controller: :users

  resources :users
  resource :session, only: [:new, :create, :destroy]

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'

  root 'sessions#new'
end
