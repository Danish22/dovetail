class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:show, :edit, :update, :destroy]

  # GET /payment_methods
  # GET /payment_methods.json
  def index
    @payment_methods = current_user.payment_methods.all
  end

  # GET /payment_methods/1
  # GET /payment_methods/1.json
  def show
  end

  # GET /payment_methods/new
  def new
    @payment_method = current_user.payment_methods.new

    # Default values to the current user
    @payment_method.billing_email = current_user.email
    @payment_method.billing_name = current_user.full_name
  end

  # GET /payment_methods/1/edit
  def edit
  end

  # POST /payment_methods
  # POST /payment_methods.json
  def create
    @payment_method = current_user.payment_methods.new(payment_method_params)

    begin
      respond_to do |format|
        if @payment_method.save
          
          # Raises an exception on card error.
          @payment_method.update_stripe()  #Does two saves (here and update_attributes), but it's okay
          
          format.html { redirect_to @payment_method, notice: 'Payment method was successfully created.' }
          format.json { render :show, status: :created, location: @payment_method }
        else
          format.html { render :new }
          format.json { render json: @payment_method.errors, status: :unprocessable_entity }
        end
      end
    rescue Stripe::CardError => e
      Rails.logger.info("Card error #{e.message}")
      @payment_method.errors.add :base, e.message
      @payment_method.stripe_token = nil
      render :new
    rescue Stripe::StripeError => e
      Rails.logger.error "StripeError: " + e.message
      @payment_method.errors.add :base, "There was a problem with your credit card"
      @payment_method.stripe_token = nil
      render :new
    end
  end

  # PATCH/PUT /payment_methods/1
  # PATCH/PUT /payment_methods/1.json
  def update
    begin
      respond_to do |format|
        if @payment_method.update(payment_method_params)
          
          # Raises an exception on card error.
          @payment_method.update_stripe()  #Does two saves (here and update_attributes), but it's okay
            
          format.html { redirect_to @payment_method, notice: 'Payment method was successfully updated.' }
          format.json { render :show, status: :ok, location: @payment_method }
        else
          format.html { render :edit }
          format.json { render json: @payment_method.errors, status: :unprocessable_entity }
        end
      end
    rescue Stripe::CardError => e
      Rails.logger.info("Card error #{e.message}")
      @payment_method.errors.add :base, e.message
      @payment_method.stripe_token = nil
      render :edit
    rescue Stripe::StripeError => e
      Rails.logger.error "StripeError: " + e.message
      @payment_method.errors.add :base, "There was a problem with your credit card"
      @payment_method.stripe_token = nil
      render :edit
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.json
  def destroy
    @payment_method.destroy
    respond_to do |format|
      format.html { redirect_to payment_methods_url, notice: 'Payment method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_method
      @payment_method = current_user.payment_methods.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_method_params
      params.require(:payment_method).permit(:billing_name, :billing_email, :company_name, :stripe_token)
    end
end
