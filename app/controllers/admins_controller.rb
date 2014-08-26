class AdminsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space

  def index
    @admins = @space.users
    @invites = @space.invites.where(recipient_id: nil) # Pending/Unaccepted invites
    @invite = @space.invites.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = current_user.spaces.find(params[:space_id])
    end
end

