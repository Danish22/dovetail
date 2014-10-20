class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :quantity
      t.boolean :unlimted
      t.references :space, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
