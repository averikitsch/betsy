Rails.application.routes.draw do

  resources :order_products

  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :categories, only: [:new, :create, :index] do
    resources :products, only: [:index]
  end

  resources :users

  resources :orders

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
