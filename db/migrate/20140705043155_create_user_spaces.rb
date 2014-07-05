class CreateUserSpaces < ActiveRecord::Migration
  def change
    create_table :user_spaces do |t|
      t.references :user, index: true
      t.references :space, index: true

      t.timestamps
    end
  end
end
