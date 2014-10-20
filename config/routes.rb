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
    resources :locations
    resources :invites do
      member do
        get 'resend'
      end
    end
    resources :admins
    resources :resources
    resources :plans
  end

  devise_for :users, :controllers => { :registrations => "registrations" }
  root to: 'members#index'
end
