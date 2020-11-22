Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'

  resources :users, except: [:new, :index, :destroy]
  resources :products do 
    resources :order_items, only: [:create]
  end

  resources :orders, except: [:index, :update, :edit, :destroy]
  resources :order_items, except: [:index, :new, :edit]
  
  #login and logout routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  # Customized actions
  get "/cart", to: "orders#cart", as: "cart"
  patch '/cart/orderitem/:id', to: 'order_items#update', as: 'cart_update'
  get "/confirmation", to: "orders#confirmation", as: "confirmation"
  patch 'products/:id/retired', to: 'products#retired', as: 'retired_product'
  patch 'order_items/:id/shipped', to: 'order_items#shipped', as: 'shipped_order_item'
  patch 'order_items/:id/cancelled', to: 'order_items#cancelled', as: 'cancelled_order_item'

end
