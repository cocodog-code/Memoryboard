Rails.application.routes.draw do
  get 'password_edits/edit'
  root 'static_pages#home'
  get    '/signup', to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :password_edits, only: [ :edit, :update ]
end