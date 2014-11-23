class StripeIntegration < Integration

  def charge_member(member, amount, currency, description = "")

    if member.payment_system_customer_id.blank?
      raise "Something's not right, attempting to charge a member with no stripe customer id associated with them" 
    end

    # Charge the Customer, if this raises an exception, the caller will deal with it.
    ch = Stripe::Charge.create( {amount: (amount * 100).to_i, # in cents
                                  currency: currency,
                                  description: description,
                                  customer: member.payment_system_customer_id}, 
                                oauth_access_token)    
  end

  def update_customer(member)
    if member.payment_system_customer_id.nil?
      if !member.payment_system_token.present?
        raise "We're doing something wrong -- this isn't supposed to happen"
      end

      customer = Stripe::Customer.create({
        :email => member.email,
        :description => stripe_description(member),
        :card => member.payment_system_token
      }, oauth_access_token)

      member.last_4_digits = customer.cards.retrieve(customer.default_card).last4
    else
      customer = Stripe::Customer.retrieve(member.payment_system_customer_id, oauth_access_token)

      if member.payment_system_token.present?
        customer.card = member.payment_system_token
      end

      # in case they've changed
      customer.email = member.email
      customer.description = stripe_description(member)

      customer.save

      self.last_4_digits = customer.cards.retrieve(customer.default_card).last4      
    end

    member.payment_system_customer_id = customer.id

    member.save
  end

  def stripe_publishable_key
    settings['stripe_publishable_key']
  end

  def stripe_publishable_key=(key)
    settings['stripe_publishable_key'] = key
  end

  def configured?
    connected? && !oauth_access_token.blank?
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

  def stripe_description(member)
    "#{member.name} : #{member.email}"
  end

end
