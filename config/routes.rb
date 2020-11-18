Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resources :users, except: [:new, :index]
  resources :products

  # Costomerized actions
  patch 'products/:id/retired', to: 'products#retired', as: 'retired_product'

end
