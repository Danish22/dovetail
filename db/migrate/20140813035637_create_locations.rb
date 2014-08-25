class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :address_id
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :timezone
      t.string :currency
      t.decimal :tax_rate
      t.integer :space_id

      t.timestamps
    end
  end
end
