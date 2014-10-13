class FixMemberRelationships < ActiveRecord::Migration
  def change
    drop_table :space_members
    drop_table :location_members

    add_column :members, :location_id, :integer
  end
end
