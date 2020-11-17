Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/edit'
  get 'products/index'
  get 'products/show'
  get 'products/new'
  get 'products/edit'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
