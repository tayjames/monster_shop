Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  resources :users, only: [:new]

  get '/register', to: 'users#register'
  get '/profile', to: 'users#show'
  post '/profile', to: 'users#create'
  get '/profile/edit', to: 'users#edit', as: 'edit_profile'
  get '/profile/edit_password', to: 'users#edit_password', as: 'edit_password'
  put 'profile/', to: 'users#update'
  patch 'profile/', to: 'users#update_password', as: 'update_password'
  get 'profile/orders', to: 'orders#index', as: 'profile_orders'
  get 'profile/order/:id', to: 'orders#show', as: 'profile_order'
  post '/profile/orders', to: 'orders#create', as: 'create_order'
  patch 'profile/order/:id', to: 'orders#update', as: 'update_profile_order'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create', as: 'user_login'
  get '/logout', to: 'sessions#destroy'



  namespace :merchant do
    get '/dashboard', to: 'dashboard#index', as: 'dashboard'
    get '/', to: 'dashboard#show', as: 'dashboard_show'
  end

  namespace :admin do
    # get '/users', to: "dashboard#all", as: 'all_users'
    get '/users', to: "users#index", as: 'all_users'
    get '/users/:id', to: "users#show"
    get '/dashboard', to: 'dashboard#index', as: :dashboard
    get '/merchants/:id', to: "merchants#show", as: 'merchants_show'
    put '/merchants/:id', to: 'merchants#disable', as: :disable
    patch '/merchants/:id', to: 'merchants#enable', as: :enable
  end
end
