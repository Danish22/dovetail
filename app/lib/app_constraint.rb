class AppConstraint
  def self.matches?(request)  
    !request.subdomain.present? || ( request.subdomain.present? && ["admin", "manage", "secure", "ssl", "app"].include?(request.subdomain) )
  end  
end 
