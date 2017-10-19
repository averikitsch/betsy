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

  resources :users do
    resources :products, only: [:index]
  end

  resources :orders


  post '/products/:id/order', to: 'order_products#create', as: 'order_products'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
