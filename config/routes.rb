Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'

  resources :users, except: [:new, :index]
  resources :products
  resources :orders
  resources :order_items

  get "/cart", to: "orders#cart", as: "cart"
  
  #login and logout routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

  # Customized actions
  patch 'products/:id/retired', to: 'products#retired', as: 'retired_product'

end
