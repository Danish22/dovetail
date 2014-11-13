
Rails.application.routes.draw do

  resources :payment_methods

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Note most everything will be a nested resource of spaces
  resources :spaces do
    member do
      post 'cancel_subscription'
    end

    resources :members do
      member do 
        get 'account'  # Account is the 'index' page for invoices, payments and credit notes.
      end
      resources :invoices, except: [:index]
      resources :payments, except: [:index]
      resources :credit_notes, except: [:index]
    end

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

  constraints(Subdomain) do  
    get '/' => 'member_portal#account'    
  end 

  root to: 'members#index'
end
