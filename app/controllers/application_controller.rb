class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_payment_method
  before_action :force_space_creation
  #before_action :set_default_space

  layout :layout_by_resource


  #around_filter :space_time_zone, :if => :has_timezone

  def space_time_zone(&block)
    Time.use_zone(current_account.timezone, &block)
  end

  def set_default_space
    @space = current_user.default_space if current_user
  end

  def force_space_creation
    if current_user && current_user.spaces.count < 1
      redirect_to new_space_path unless params[:controller] == "spaces" && (params[:action] == "new"  || params[:action] == "create")
    end
  end

  protected
 
  def layout_by_resource
    # if devise_controller?
    #   "devise"
    # else
    #   "application"
    # end
    "application"
  end

  def has_timezone
    @space && !@space.timezone.nil? && !@space.timezone.blank?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :promo_code
    devise_parameter_sanitizer.for(:sign_up) << :invite_token
    devise_parameter_sanitizer.for(:sign_up) << :full_name
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name

    devise_parameter_sanitizer.for(:sign_up) << :full_name
    devise_parameter_sanitizer.for(:account_update) << :first_name
    devise_parameter_sanitizer.for(:account_update) << :last_name
  end

  def check_payment_method

    return if self.controller_name == "payment_methods" && self.action_name == "new"

    if user_signed_in?
      unless current_user.trialing?
        if current_user.payment_methods.count == 0
          # Trial has expired, need payment method on file.  
          # Will display a nag warning in layout
          @need_payment_method = true
        end
      end
    end
  end

  # Call from any controllers in spaces or nested underneath
  def check_space_payment_method
    if user_signed_in?
      unless current_user.trialing?
        if @space && (@space.payment_method.nil? || @space.stripe_subscription_id.blank?)
          flash[:notice] = "Your trial has ended, please select a payment method." 
          redirect_to edit_space_path(@space)
        end
      end
    end
  end

  def set_space
    @space = current_user.spaces.friendly.find(params[:space_id])
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

end
