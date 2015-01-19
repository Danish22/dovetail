
Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  constraints(Portal) do  

    get '/' => 'member_portal#account', as: 'portal_account'
    post '/' => 'member_portal#create_identity'    

    # Account history 
    get '/:ledger_item_id/details' => 'member_portal#details'
    post '/:ledger_item_id/makepayment' => 'member_portal#make_payment'

    # Credit card stuff
    get '/credit_card' => 'member_portal#credit_card'
    patch '/update_card' => 'member_portal#update_card'

    # Authentication/sessions  routes
    post '/auth/:provider/callback', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
  end 

  constraints(AppConstraint) do

    root to: 'spaces#index'

    resources :payment_methods, path: "billing"

    get '/integrations/stripe/callback', to: "integrations/stripes#callback"
    devise_for :users, :controllers => { :registrations => "registrations" }    
        
    # Note most everything will be a nested resource of spaces
    resources :spaces, path: "" do
      member do
        post 'cancel_subscription'
      end
      
      get 'activities', to: 'activities#index'
      get 'insights', to: 'insights#index'

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

      resources :members do
        member do 
          post 'invite'  # Send the invite email with the sign up token to the member
        end
        resources :member_invoices, path: "invoices", controller: "invoices", except: [:index] do
          member do
            post 'deliver'
          end
        end
        resources :member_payments, path: "payments", controller: "payments", except: [:index]
        resources :member_credit_notes, path: "credit_notes", controller: "credit_notes", except: [:index]
      end     
    end  # Spaces

  end
end
