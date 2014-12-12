class Integrations::BaseController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :check_space_payment_method
  before_action :prepare_integration

  def create
    @integration = new_record

    respond_to do |format|
      if @integration.save
        format.html { redirect_to redirect_url, notice: "#{integration_name} is now connected to Dovetail." }
        format.json { render json: @integration, status: :created, location: @integration }
      else
        format.html { render action: "show" }
        format.json { render json: @integration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if update_entity
        format.html { redirect_to redirect_url, notice: "#{integration_name} settings have been updated." }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @integration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy    
    @integration.destroy if @integration.connected?

    respond_to do |format|
      format.html { redirect_to integrations_url }
      format.json { head :no_content }
    end
  end

  protected

end
