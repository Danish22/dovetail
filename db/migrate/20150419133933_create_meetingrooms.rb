class CreateMeetingrooms < ActiveRecord::Migration
  def change
    create_table :meetingrooms do |t|
      t.integer :space_id
      t.integer :location_id
      t.string :name
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
