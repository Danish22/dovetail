class AdminsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space

  def index
    @admins = @space.users
    @invites = @space.invites.where(recipient_id: nil) # Pending/Unaccepted invites
    @invite = @space.invites.new
  end

  def destroy
    @space.users.delete(@space.users.find(params[:id]))

    respond_to do |format|
      format.html { redirect_to space_admins_url(@space), notice: 'Manager was successfully removed' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end

