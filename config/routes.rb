Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'

  resources :users, except: [:new, :index, :destroy] do
    get 'show_products', on: :member
    get 'show_fulfillments', on: :member
  end

  get '/products/clear', to: 'products#clear', as: 'clear'
  resources :products do 
    resources :order_items, only: [:create]
    resources :reviews, only: [:new, :create]
  end

  resources :categories, only: [:create]

  resources :orders, except: [:index, :update, :edit, :destroy]
  resources :order_items, except: [:index, :new, :edit]
  resources :reviews, only: [:edit, :update, :destroy]
  
  #login and logout routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  # Customized actions
  get "/about", to: "extrapages#about", as: "about"

  get "/cart", to: "orders#cart", as: "cart"
  patch '/cart/order_item/:id', to: 'order_items#update', as: 'cart_update'

  get "/orders/:id/payment", to: 'orders#payment', as: 'payment'
  patch '/orders/:id/complete', to: 'orders#complete', as: 'complete'
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "confirmation"

  patch '/products/:id/retired', to: 'products#retired', as: 'retired_product'

  patch '/order_items/:id/shipped', to: 'order_items#shipped', as: 'shipped_order_item'
  patch '/order_items/:id/cancelled', to: 'order_items#cancelled', as: 'cancelled_order_item'
  
end
