class CreditNotesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_member
  before_action :set_credit_note, only: [:show, :edit, :update, :destroy]
  before_action :check_space_payment_method

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @credit_note = @member.member_credit_notes.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @credit_note = @member.member_credit_notes.new(member_params)
    @credit_note.sender = @space

    respond_to do |format|   
      if @credit_note.save
        format.html { redirect_to account_space_member_url(@space, @member), notice: 'CreditNote was successfully created.' }
        format.json { render :show, status: :created, location: [@space, @member, @credit_note] }
      else
        format.html { render :new }
        format.json { render json: @credit_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @credit_note.update(member_params)
        format.html { redirect_to account_space_member_url(@space, @member), notice: 'CreditNote was successfully updated.' }
        format.json { render :show, status: :ok, location: [@space, @member, @credit_note] }
      else
        format.html { render :edit }
        format.json { render json: @credit_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @credit_note.destroy
    respond_to do |format|
      format.html { redirect_to  account_space_member_url(@space, @member), notice: 'CreditNote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_note
      @credit_note = @member.member_credit_notes.find(params[:id])
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
      params.require(:credit_note).permit()
    end
end
