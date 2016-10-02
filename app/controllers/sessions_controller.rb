# This is for Member login...
class SessionsController < PortalApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    auth = request.env["omniauth.auth"]
    member = @space.members.where(provider: auth["provider"], uid: auth["uid"]).first
    session[:member_id] = member.id unless member.nil?  # Probably should never happen, but...
    redirect_to "/"
  end

  def destroy
    unauthenticate_member!
  end

  def failure
    redirect_to '/', :alert => "Authentication error: #{params[:message].humanize}"
  end
  
  protected
end
