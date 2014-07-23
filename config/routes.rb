Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Note most everything will be a nested resource of spaces
  resources :spaces do
    resources :members
  end

  devise_for :users
  root 'members#index'
end
