class MembersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :check_space_payment_method

  # GET /members
  # GET /members.json
  def index
    @members = @space.members.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = @space.created_members.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = @space.created_members.new(member_params)
    @member.user = current_user

    respond_to do |format|   
      if @member.save
        @space.members << @member

        format.html { redirect_to [@space, @member], notice: 'Member was successfully created.' }
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
        format.html { redirect_to [@space, @member], notice: 'Member was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = @space.members.find(params[:id])
    end

    def set_space
      if params[:space_id].blank?
        @space = current_user.spaces.first
        redirect_to space_members_path(@space)
      else
        @space = current_user.spaces.find(params[:space_id])
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :email, :space_id, :user_id)
    end
end
