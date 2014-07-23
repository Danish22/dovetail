Rails.application.routes.draw do

  resources :payment_methods

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Note most everything will be a nested resource of spaces
  resources :spaces do
    member do
      post 'cancel_subscription'
    end
    resources :members
  end

  devise_for :users
  root to: 'members#index'
end
