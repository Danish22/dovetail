class PaymentMethod < ActiveRecord::Base

  belongs_to :user
  has_many :spaces

  before_destroy :cancel_subscriptions

  # Represents the card, only present when setting up or updating subscription
  attr_accessor :stripe_token 

  # Create or Update an existing subscription (ie change plan)
  def update_subscription(space, coupon)

    # Should never happen, but want it to scream load if it does
    raise "Missing Stripe Id" if stripe_id.blank?

    customer = Stripe::Customer.retrieve(stripe_id, ENV['STRIPE_API_KEY'])

    if  space.stripe_subscription_id.blank?
      # Set up a new subscription
      params = {plan: space.plan}
      params.merge!({coupon: coupon}) unless coupon.blank?
      subscription = customer.subscriptions.create(params)

      space.stripe_subscription_id = subscription.id
      space.payment_method = self  

      space.save!
    else
      # Update an existing subscription
      subscription = customer.subscriptions.retrieve(space.stripe_subscription_id)
      subscription.plan = space.plan
      subscription.coupon = coupon unless coupon.blank?
      subscription.save
    end
  end

  # Cancels a subscription
  def cancel_subscription(space)

    raise "Missing Stripe Id" if stripe_id.blank?
    raise "Missing subscription Id" if space.stripe_subscription_id.blank?

    customer = Stripe::Customer.retrieve(stripe_id, ENV['STRIPE_API_KEY'])
    customer.subscriptions.retrieve(space.stripe_subscription_id).delete

    space.stripe_subscription_id = nil
    space.payment_method = nil # Removes 'self' from space as the payment method

    space.save!
  end

  #  Remove subscriptions on delete 
  def cancel_subscriptions
    spaces.each do |space|
      cancel_subscription(space)
    end
  end  

  # Creates or updates a Stripe customer record.  Exception handling is done in the controller
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

  def select_name
    "#{self.billing_name} <#{self.billing_email}> Card on file: **** **** **** #{self.last_4_digits}"
  end
end
