json.array!(@members) do |member|
  json.extract! member, :id, :name, :email, :space_id, :user_id
  json.url member_url(member, format: :json)
end
