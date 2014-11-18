class IntegrationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :check_space_payment_method

  def index    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  protected
    def set_space
      @space = current_user.spaces.find(params[:space_id])
    end

end
