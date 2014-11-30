#
# What members see
#
class MemberPortalController < PortalApplicationController

  def account

    if current_member
      @ledger_items = current_member.ledger_items.in_effect.order("issue_date DESC")
    end

    @identity = MemberIdentity.new # Really only used on signup
  end

  def details
    @item = current_member.ledger_items.find(params[:ledger_item_id])
  end

  def create_identity
    @identity = MemberIdentity.new(identity_params)
    @identity.email = current_member.email
    @identity.subdomain = @space.subdomain

    respond_to do |format|   
      if @identity.save

        m = current_member
        # Clear the invite code and link member to identity
        m.invite = nil
        m.provider = "identity"
        m.uid = @identity.id
        m.save

        format.html { redirect_to "/", notice: 'Password saved' }
      else
        format.html { render :account}
      end
    end
  end

  def credit_card
    @member = current_member
  end

  def update_card
    @member = current_member
    respond_to do |format|   
      if @member.update(credit_card_params) && @space.update_payment_system_customer(@member)
        format.html { redirect_to "/", notice: 'Card details saved' }
      else
        flash[:notice]= "There was a problem processing your card: #{@member.gateway_error}"
        format.html { render :credit_card}
      end
    end
  end

  # Stripe, Braintree, Authorize.net, etc
  def make_payment 
    @member = current_member
    @invoice = current_member.member_invoices.find(params[:ledger_item_id])

    raise "Invoice is already paid" if @invoice.paid?

    respond_to do |format|   
      payment = @space.charge_member(@member, @invoice.total_amount, @invoice.description)
      @invoice.children << payment

      if payment.status == "cleared"
        format.html { redirect_to "/", notice: 'Payment succeeded' }
      else
        flash[:notice]= payment.description
        format.html { redirect_to "/", notice: payment.description }
      end
    end
  end

  protected
  # Never trust parameters from the scary internet, only allow the white list through.
  def credit_card_params
    params.require(:member).permit(:payment_system_token)
  end

  def identity_params
    params.require(:member_identity).permit(:password, :password_confirmation)
  end

end
