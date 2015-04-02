Rails.application.routes.draw do

  root 'static#index'

  get '/users/twitterlogin' => :twitter_login, controller: :users

  get '/users/twitter_callback' => :twitter_callback, controller: :users

  # NYTimes API requests
  get '/nytimes_fetch', to: 'nyt#get_article'
  get '/nytimes_facet', to: 'nyt#topic'

  # User input for search 
  post '/user_choice', to: 'nyt#user_choice'
  get '/user_choice', to: 'nyt#user_choice'

  # User nytimes cliked topic for tweets & guidestar 
  post '/user_click', to: 'nyt#user_click'
  get '/user_click', to: 'nyt#user_click'

  # Guidestair API request
  get '/guidestar_fetch', to: 'guidestar#get_org'

  # Dashboard / main page
  get '/dashboard', to: 'static#index'

  resources :users
  resource :session, only: [:new, :create, :destroy]

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  
end
