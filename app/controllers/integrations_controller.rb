class IntegrationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :check_space_payment_method

  def index    
    if stale?(@space)
      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

  protected
end
