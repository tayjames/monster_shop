Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :merchants do
    resources :items, only: :index
  end
  # get '/merchants/:merchant_id/items', to: items#index
  # get '/merchants', to: merchants#index
  # post '/merchants', to: merchants#create
  # get '/merchants/new', to: merchants#new
  # get '/merchants/edit', to: merchants#edit
  # get '/merchants/:id', to: merchants#show
  # patch '/merchants/:id', to: merchants#update
  # put '/merchants/:id', to: merchants#update
  # delete '/merchants/:id', to: merchants#destroy

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end
  # post '/items/:item_id/reviews', to: reviews#create
  # get '/items/:item_id/reviews/new', to: reviews#new
  # get '/items', to: items#index
  # get '/items/edit', to: items#edit
  # get '/items/:id', to: items#show
  # patch '/items/:id', to: items#update
  # put '/items/:i'd', to: items#update
  # delete '/items/:id', to: items#destroy

  resources :reviews, only: [:edit, :update, :destroy]
  # get '/reviews/:id/edit', to: reviews#edit
  # patch '/reviews/:id', to: reviews#update
  # put '/reviews/:id', to: reviews#update
  # delete '/reviews/:id', to: reviews#delete

  get '/cart', to: 'cart#show'
  # resources :cart, only: [:show]
  post '/cart/:item_id', to: 'cart#add_item'
  #non restful
  delete '/cart', to: 'cart#empty'
  #non restful
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  #non restful
  delete '/cart/:item_id', to: 'cart#remove_item'
  #non restful

  resources :users, only: [:new]
  # get '/users/new', to: users#new

  get '/register', to: 'users#register'
  get '/profile', to: 'users#show', as: 'profile'
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
    get '/:id/items', to: 'items#index'
    patch 'items/:id/activate', to: 'items#activate', as: 'activate'
    patch 'items/:id/deactivate', to: 'items#deactivate', as: 'deactivate'
    get '/orders/:order_id', to: 'orders#show', as: 'orders_show'
    patch '/orders/:order_items_id', to: 'orders#update', as: 'item_fulfill'
    get '/items', to: 'items#index', as: 'items_index'
    get '/items/new', to: 'items#new'
    get '/items/:id/edit', to: 'items#edit', as: 'items_edit'
    patch '/items', to: 'items#update'
    post '/items', to: 'items#create'
    delete 'items/:id', to: 'items#destroy', as: 'item_delete'
  end

  namespace :admin do
    get '/users', to: "users#index", as: 'all_users'
    get '/users/:id', to: "users#show"
    get '/dashboard', to: 'dashboard#index', as: :dashboard
    get '/merchants/:id', to: "merchants#show", as: 'merchants_show'
    get '/merchants', to: "merchants#index"
    put '/merchants/:id', to: 'merchants#disable', as: :disable
    patch '/merchants/:id', to: 'merchants#enable', as: :enable
    patch '/orders/:id', to: 'orders#update', as: 'order_ship'
  end
end
