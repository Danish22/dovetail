class PaymentMethod < ActiveRecord::Base

  belongs_to :user
  #has_many :spaces # Coming Soon

  # Create/update customer details in stripe.
  def update_stripe
  end

  # Update an existing subscription (ie change plan)
  def update_subscription(space)
  end

  # Cancels a subscription
  def cancel_subscription(space)
  end

end
