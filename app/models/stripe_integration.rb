class StripeIntegration < Integration

  def stripe_publishable_key
    settings['stripe_publishable_key']
  end

  def stripe_publishable_key=(key)
    settings['stripe_publishable_key'] = key
  end

  def configured?
    connected? && settings.has_key?("access_token")
  end

  def user_added(user)
    # These are no-ops
  end

  def user_updated(user)
    # These are no-ops
  end

  protected 

  def get_connection()
  end

  def with_connection(&block)
  end

end
