class RenameIdentitiesToMemberIdentities < ActiveRecord::Migration
  def change
    rename_table :identities, :member_identities
  end
end
