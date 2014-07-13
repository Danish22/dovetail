class PaymentMethod < ActiveRecord::Base

  belongs_to :user
  #has_many :spaces # Coming Soon

  # Represents the card, only present when setting up or updating subscription
  attr_accessor :stripe_token 

  # Update an existing subscription (ie change plan)
  def update_subscription(space)
      #params = {:plan => self.plan}
      #params.merge!({:coupon => self.coupon}) unless self.coupon.blank?
      #response = customer.update_subscription(params)
  end

  # Cancels a subscription
  # TOOD Implement properly w/rt multiple subscriptions
  def cancel_subscription(space)
    if !stripe_id.blank?
      customer = Stripe::Customer.retrieve(stripe_id, ENV['STRIPE_API_KEY'])
      params = {} #:plan => self.plan
      if customer.cancel_subscription(params)
        self.stripe_token = nil
        self.last_4_digits
        self.save
      else
        return false
      end
    else
      return true
    end
  end

  def update_stripe()
    if stripe_id.nil?
      if !stripe_token.present?
        raise "We're doing something wrong -- this isn't supposed to happen"
      end

      customer = Stripe::Customer.create({
                                           :email => billing_email,
                                           :description => stripe_description,
                                           :card => stripe_token
                                         },
                                         ENV['STRIPE_API_KEY'])
                                         
      self.last_4_digits = customer.cards.retrieve(customer.default_card).last4
    else
      customer = Stripe::Customer.retrieve(stripe_id, ENV['STRIPE_API_KEY'])

      if stripe_token.present?
        customer.card = stripe_token
      end

      # in case they've changed
      customer.email = billing_email
      customer.description = stripe_description

      customer.save

      self.last_4_digits = customer.cards.retrieve(customer.default_card).last4
    end

    self.stripe_id = customer.id
    self.stripe_token = nil

    self.save
  end

  def stripe_description
    "#{self.billing_name} : #{self.billing_email}"
  end

  # TODO (s)
  #  * Handle dormant accounts
  #  * Remove subscriptions on delete (or disallow delete while active subscriptions?!?)
  

end
