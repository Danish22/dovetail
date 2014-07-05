class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :fax
      t.string :website
      t.string :country
      t.string :postal
      t.string :timezone
      t.string :currency
      t.string :slug
      t.references :user, index: true

      t.timestamps
    end
  end
end
