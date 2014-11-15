class AddSubdomainToSpace < ActiveRecord::Migration
  def change
    add_column :spaces, :subdomain, :string
  end
end
