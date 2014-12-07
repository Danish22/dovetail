class InvoicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_member
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :deliver]
  before_action :check_space_payment_method

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @invoice = @member.member_invoices.new
    10.times do
      @invoice.line_items.build()
    end
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @invoice = @member.member_invoices.new(member_params)

    @invoice.sender = @space
    @invoice.status = "open"
    @invoice.issue_date = Time.now
    @invoice.currency = @member.location.currency

    respond_to do |format|   
      if @invoice.save
        format.html { redirect_to account_space_member_url(@space, @member), notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: [@space, @member, @invoice] }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @invoice.update(member_params)
        format.html { redirect_to account_space_member_url(@space, @member), notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: [@space, @member, @invoice] }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def deliver
    respond_to do |format|
      @invoice.update_attribute(:status, "closed")

      host = ENV["PORTAL_BASE_HOST"] || Rails.application.config.action_mailer.default_url_options[:host]
      needs_account = (@member.uid.blank? && @member.provider.blank?)
      if needs_account
        @member.invite = Digest::SHA1.hexdigest([@space.id, Time.now, rand].join)
        @member.save
        url = portal_account_url(host: host, subdomain: @space.subdomain, invite: @member.invite)      
      else
        url = portal_account_url(host: host, subdomain: @space.subdomain)      
      end

      PaymentMailer.invoice(curent_user, @member, @invoice, url, needs_account).deliver

      format.html { redirect_to account_space_member_url(@space, @member), notice: 'Invoice has been sent' }
      format.json { render :show, status: :ok, location: [@space, @member, @invoice] }
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to  account_space_member_url(@space, @member), notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = @member.member_invoices.find(params[:id])
    end

    def set_member
      @member = @space.members.find(params[:member_id])
    end

    def set_space
      if params[:space_id].blank?
        @space = current_user.default_space
        redirect_to space_members_path(@space)
      else
        @space = current_user.spaces.find(params[:space_id])
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member_invoice).permit(:description, :due_date, :identifier, 
                                      line_items_attributes: [ :description, :tax_amount, :net_amount])
    end
end
