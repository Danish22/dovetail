json.array!(@bookings) do |booking|
  json.extract! booking, :id, :space_id, :location_id, :meetingroom_id, :member_id, :starting, :ending
  json.url booking_url(booking, format: :json)
end
