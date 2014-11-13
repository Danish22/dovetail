class Subdomain  
  def self.matches?(request)  
    request.subdomain.present? && !["admin", "manage", "secure", "ssl", "app"].include?(request.subdomain)
  end  
end 
