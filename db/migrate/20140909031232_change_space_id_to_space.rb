class ChangeSpaceIdToSpace < ActiveRecord::Migration
  def change
    remove_column :locations, :address_id, :integer
    add_column :locations, :address, :string
  end
end
