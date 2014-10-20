json.array!(@resources) do |resource|
  json.extract! resource, :id, :name, :quantity, :unlimted, :space_id, :location_id
  json.url resource_url(resource, format: :json)
end
