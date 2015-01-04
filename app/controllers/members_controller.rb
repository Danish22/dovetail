class MembersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_member, only: [:show, :edit, :update, :destroy, :account, :invite]
  before_action :check_space_payment_method

  # GET /members
  # GET /members.json
  def index
    if stale?(@space)
      @members = @space.members.all.order("name asc")
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    if stale?(@member)
      @ledger_items = @member.member_invoices.order("created_at desc")
      @history_items = @member.ledger_items
        .where(status: ["closed", "cleared", "failed"])
        .order("created_at desc")
        .limit(6)
    end
  end

  # GET /members/new
  def new
    @member = @space.members.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = @space.members.new(member_params)
    @member.user = current_user

    respond_to do |format|   
      if @member.save
        @space.members << @member

        format.html { redirect_to space_member_url(@space, @member), notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: [@space, @member] }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to space_member_url(@space, @member), notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: [@space, @member] }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to space_members_url(@space), notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def invite

    raise "Member is already signed up" unless @member.provider.blank?

    @member.invite = Digest::SHA1.hexdigest([@space.id, Time.now, rand].join)
    @member.save
    
    host = ENV["PORTAL_BASE_HOST"] || Rails.application.config.action_mailer.default_url_options[:host]
    url = portal_account_url(host: host, subdomain: @space.subdomain, invite: @member.invite)

    InvitesMailer.member_invite(current_user, @member, url).deliver

    respond_to do |format|
      format.html { redirect_to space_members_url(@space), notice: 'Member invite sent' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = @space.members.friendly.find(params[:id])
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
      params.require(:member).permit(:name, :email, :location_id, :plan_id)
    end
end
