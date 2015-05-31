json.array!(@meetingrooms) do |meetingroom|
  json.extract! meetingroom, :id, :space_id, :location_id, :name, :description, :user__id
  json.url meetingroom_url(meetingroom, format: :json)
end
