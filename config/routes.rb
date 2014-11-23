
Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  constraints(Portal) do  

    get '/' => 'member_portal#account', as: 'portal_account'
    post '/' => 'member_portal#create_identity'    

    # Account history 
    get '/:ledger_item_id/details' => 'member_portal#details'

    # Credit card stuff
    get '/credit_card' => 'member_portal#credit_card'
    patch '/update_card' => 'member_portal#update_card'

    # Authentication/sessions  routes
    post '/auth/:provider/callback', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
  end 

  constraints(AppConstraint) do
    resources :payment_methods
        
    # Note most everything will be a nested resource of spaces
    resources :spaces do
      member do
        post 'cancel_subscription'
      end
      
      resources :members do
        member do 
          get 'account'  # Account is the 'index' page for invoices, payments and credit notes.
          post 'invite'  # Send the invite email with the sign up token to the member
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

      get 'integrations', to: 'integrations#index'
      namespace :integrations do
        resource :mailchimp, only: [:show, :create, :update, :destroy]        
        resource :stripe, only: [:show, :destroy] do
          get 'authorize', on: :member
          get 'callback', on: :member
        end
      end

    end

    get '/integrations/stripe/callback', to: "integrations/stripes#callback"
    devise_for :users, :controllers => { :registrations => "registrations" }    

  end
  root to: 'members#index'
end
