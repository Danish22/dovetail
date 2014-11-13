class Portal
  def self.matches?(request)  
    Rails.logger.info("request.subdomain.present? = #{request.subdomain.present?}, subdomain = #{request.subdomain}")

    request.subdomain.present? && !["admin", "manage", "secure", "ssl", "app"].include?(request.subdomain)
  end  
end 
