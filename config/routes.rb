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

  resources :orders, only: [:new, :create, :show]

  resources :users, only: [:new]

  get '/register', to: 'users#register'
  get '/profile', to: 'users#show'
  post '/profile', to: 'users#create'
  get '/profile/:id', to: 'users#show', as: 'user_profile'
  get '/profile/:id/edit', to: 'users#edit', as: 'edit_user_profile'
  patch 'profile/:id', to: 'users#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create', as: 'user_login'
  get '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  end

  namespace :admin do
    get '/users', to: "dashboard#all", as: 'all_users'
    get '/dashboard', to: 'dashboard#index', as: :dashboard
  end
end
