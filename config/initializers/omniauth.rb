
def rack_subdomain(req)
  return req.host.split(".").first
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,  :model => MemberIdentity, :locate_conditions => lambda { |req| { model.auth_key => req['auth_key'], :subdomain => rack_subdomain(req) }}
end
