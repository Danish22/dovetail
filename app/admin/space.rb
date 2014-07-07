ActiveAdmin.register Space do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  menu priority: 1 

  index do
    id_column
    column :name
    column :user
    column :created_at
    actions
  end  
  
  sidebar :help, priority: 0 do
    "Need help? Email us at help@example.com"
  end

  filter :user
  filter :users
  filter :name
  filter :country
  filter :created_at

end
