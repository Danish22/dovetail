ActiveAdmin.register User do

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
  menu priority: 3

  index do
    id_column
    column :email
    column :created_at
    actions
  end  

  filter :created_spaces
  filter :created_mmebers
  filter :name
  filter :email
  filter :created_at
  
end
