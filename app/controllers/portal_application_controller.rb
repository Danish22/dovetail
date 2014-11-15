#
# Base controller for member portal controllers - we're essentially our own app here.
#
class PortalApplicationController < ActionController::Base

  before_action :current_space
  before_action :login_from_invite

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_member

  layout 'portal'

  protected 

  def member_signed_in?
    !!current_member
  end
  
  def current_member
    return nil unless session[:member_id]
    @current_member ||= @space.members.find(session[:member_id]) if session[:member_id]
  end
  
  def authenticate_member!
    redirect_to "/auth/identity" unless member_signed_in? 
  end
    
  def unauthenticate_member!
    session.delete(:member_id)
    redirect_to "/"
  end

  def current_space
    @space ||= Space.where(subdomain: request.subdomain).first
    not_found if @space.nil?
  end

  def login_from_invite
    if params[:invite]
      m = @space.members.where(invite: params[:invite]).first
      session[:member_id] = m.id unless m.nil?
    end 
  end

  def not_found
    raise ActionController::RoutingError.new(:not_found)
  end
end
