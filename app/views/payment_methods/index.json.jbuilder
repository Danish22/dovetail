json.array!(@payment_methods) do |payment_method|
  json.extract! payment_method, :id, :billing_name, :billing_email, :company_nameL, :stripe_id, :user_id
  json.url payment_method_url(payment_method, format: :json)
end
