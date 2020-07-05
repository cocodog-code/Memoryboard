Rails.application.routes.draw do
  get 'password_edits/edit'
  root 'static_pages#home'
  get    '/signup', to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :password_edits, only: [:edit, :update]
  resources :microposts,     only: [:show, :create, :destroy]
  resources :microposts do
    resources :comments, only: [:create, :destroy]
  end
  resources :microposts do
    resource :favorites, only: [:create, :destroy]
  end
  resources :relationships,  only: [:create, :destroy]
end