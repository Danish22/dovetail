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

  protected
  # Never trust parameters from the scary internet, only allow the white list through.
  def identity_params
    params.require(:identity).permit(:password, :password_confirmation)
  end


end
