#
# Base controller for member portal controllers - we're essentially our own app here.
#
class PortalBaseController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'portal'

end
