json.array!(@plans) do |plan|
  json.extract! plan, :id, :name, :base_price, :setup_fee, :deposit, :frequency, :space_id, :location_id
  json.url plan_url(plan, format: :json)
end
