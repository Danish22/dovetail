json.array!(@spaces) do |space|
  json.extract! space, :id, :name, :address, :phone, :fax, :website, :country, :postal, :timezone, :currency, :slug, :user_id
  json.url space_url(space, format: :json)
end
