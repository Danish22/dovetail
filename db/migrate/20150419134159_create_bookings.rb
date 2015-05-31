class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :space_id
      t.integer :location_id
      t.integer :meetingroom_id
      t.integer :member_id
      t.datetime :starting
      t.datetime :ending

      t.timestamps
    end
  end
end
