class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :base_price
      t.decimal :setup_fee
      t.decimal :deposit
      t.string :frequency
      t.references :space, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
