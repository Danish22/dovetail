class PaymentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_member
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :check_space_payment_method

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @payment = @member.member_payments.new
    @invoice = @member.member_invoices.find(params[:invoice_id])
    @payment.invoice_id = @invoice.id
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @payment = @member.member_payments.new(member_params)
    @invoice = @member.member_invoices.find(@payment.invoice_id)

    @payment.sender = @space
    @payment.status = "cleared"
    @payment.issue_date = Time.now
    @payment.currency = @member.location.currency

    respond_to do |format|   
      if @payment.save
        @invoice.children << @payment

        format.html { redirect_to account_space_member_url(@space, @member), notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: [@space, @member, @payment] }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @payment.update(member_params)
        format.html { redirect_to account_space_member_url(@space, @member), notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: [@space, @member, @payment] }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to  account_space_member_url(@space, @member), notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = @member.member_payments.find(params[:id])
    end

    def set_member
      @member = @space.members.friendly.find(params[:member_id])
    end

    def set_space
      if params[:space_id].blank?
        @space = current_user.default_space
        redirect_to space_members_path(@space)
      else
        @space = current_user.spaces.friendly.find(params[:space_id])
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member_payment).permit(:description, :total_amount, :identifier, :invoice_id)
    end
end
