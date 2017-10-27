Rails.application.routes.draw do

  root 'products#root'

  get '/orders/lookup', to: 'orders#lookup'
  get '/orders/found', to: 'orders#found'

  resources :categories, only: [:new, :create, :index] do
    resources :products, only: [:index]
  end

  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :users do
    resources :products, only: [:index]
  end
  get '/users/:user_id/orders', to: 'users#order_fulfillment', as: 'user_orders'
  get '/about', to: 'users#about'
  get '/shipping', to: 'users#shipping'

  resources :orders, except: [:create, :edit]

  resources :order_products, only: [:edit, :update, :destroy]
  patch '/order_products/:id/cancel', to: 'order_products#cancel', as: 'cancel_order_product'
  patch '/order_products/:id/shipped', to: 'order_products#shipped', as: 'ship_order_product'
  patch 'products/:id/toggle_active', to: 'products#toggle_active', as: 'toggle_active'
  post '/products/:id/order', to: 'order_products#create', as: 'order_products'


  get '/auth/:provider/callback', to: 'users#login'
  delete '/logout', to: 'users#logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
