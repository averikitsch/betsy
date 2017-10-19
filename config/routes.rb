Rails.application.routes.draw do

  root 'products#root'

  # resources :order_products
  get '/users/:user_id/products', to: 'products#index', as: 'user_products'

  resources :categories, only: [:new, :create, :index] do
    resources :products, only: [:index]
  end

  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :users

  resources :orders


  post '/products/:id/order', to: 'order_products#create', as: 'order_products'

  get '/auth/:provider/callback', to: 'users#create', as: 'auth_callback'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
