class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :type

      t.string :api_key
      t.string :api_secret
      
      t.string :oauth_access_token
      t.string :oauth_refresh_token

      t.string :remote_account_id

      t.text :settings

      t.integer :space_id

      t.timestamps
    end
  end
end
