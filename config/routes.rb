Rails.application.routes.draw do

  get '/users/twitterlogin' => :twitter_login, controller: :users

  get '/users/twitter_callback' => :twitter_callback, controller: :users

  
  # NYTimes API requests
  get '/nytimes_fetch', to: 'nyt#get_article'
  get '/nytimes_facet', to: 'nyt#topic'

  # User input for search 
  post '/user_choice', to: 'nyt#user_choice'
  get '/user_choice', to: 'nyt#user_choice'

  # Guidestair API request
  get '/guidestar_fetch', to: 'guidestar#get_org'

  resources :users
  resource :session, only: [:new, :create, :destroy]

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'

  root 'sessions#new'
end
