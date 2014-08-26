class InvitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  def create
    @invite = @space.invites.new(invite_params)
    @invite.sender_id = current_user.id

    if @invite.save           
      if @invite.recipient != nil        
        InvitesMailer.existing_user_invite(@invite, space_path(@space)).deliver        
        @space.users << @invite.recipient
        flash[:notice] = "User added as an admin."
      else
        flash[:notice] = "Invite sent"
        InvitesMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver
      end
    else
      flash[:notice] = "There was a problem sending your invite."      
    end

    redirect_to space_admins_path(@space)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = @space.invites.find(params[:id])
    end

    def set_space
      @space = current_user.spaces.find(params[:space_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:email)
    end
end

