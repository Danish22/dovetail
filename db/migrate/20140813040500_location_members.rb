class LocationMembers < ActiveRecord::Migration
  def change
    create_table :location_members do |t|
      t.integer :member_id 
      t.integer :location_id
    end
  end
end
