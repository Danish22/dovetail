class AddInviteTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :invite, :string
  end
end
