class CreateSpaceMembers < ActiveRecord::Migration
  def change
    create_table :space_members do |t|
      t.references :space, index: true
      t.references :member, index: true

      t.timestamps
    end
  end
end
