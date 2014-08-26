class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :space_id
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
