class SpacesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space, only: [:show, :edit, :update, :destroy, :cancel_subscription]
  before_action :check_space_payment_method, only: [:show]

  # GET /spaces
  # GET /spaces.json
  def index
    @spaces = current_user.spaces.all
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
  end

  # GET /spaces/new
  def new
    @newspace = current_user.created_spaces.new
    @location = @newspace.locations.new
  end

  # GET /spaces/1/edit
  def edit
  end

  # POST /spaces
  # POST /spaces.json
  def create
    @newspace = current_user.created_spaces.new(space_params)

    respond_to do |format|
      if @newspace.save && update_subscription

        current_user.spaces << @newspace  # Creates the join record to add the admin to this space

        format.html { redirect_to space_members_path(@newspace), notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @newspace }
      else
        format.html { render :new }
        format.json { render json: @mewspace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1
  # PATCH/PUT /spaces/1.json
  def update
    respond_to do |format|
      if @space.update(space_params) && update_subscription
        format.html { redirect_to @space, notice: 'Space was successfully updated.' }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spaces/1
  # DELETE /spaces/1.json
  def destroy
    @space.destroy
    respond_to do |format|
      format.html { redirect_to spaces_url, notice: 'Space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel_subscription
    unless @space.payment_method.nil?
      @space.payment_method.cancel_subscription(@space)
    end
    respond_to do |format|
      format.html { redirect_to edit_space_url(@space), notice: 'Subscription canceled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = current_user.spaces.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_params
      params.require(:space).permit(:name, :address, :phone, :fax, :website, :country, :postal, :timezone, :currency, :slug, :user_id, :plan, 
                                    locations_attributes: [ :name, :address, :city, :state, :postal_code, :country, :timezone, :currency, :tax_rate ])
    end

    # Updates the payment method, plan and subscription
    def update_subscription
      if params[:payment_method] && !params[:payment_method].blank? && @space.payment_method.nil?
        pm = current_user.payment_methods.find(params[:payment_method]) # Create
      else
        pm = @space.payment_method  # Update
      end

      begin
        pm.update_subscription(@space, params[:coupon]) unless pm.nil?
      rescue Stripe::CardError => e
        Rails.logger.info("Card error #{e.message}")
        @space.errors.add :base, e.message
        @space.stripe_token = nil
        return false
      rescue Stripe::StripeError => e
        Rails.logger.error "StripeError: " + e.message
        @space.errors.add :base, "There was a problem with your credit card"
        @space.stripe_token = nil
        return false
      end

      return true
    end

end
