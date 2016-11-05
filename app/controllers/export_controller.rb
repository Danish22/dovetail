class ExportController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :check_space_payment_method

  def index
  end

  def members
    @members = @space.members
    respond_to do |format|
      format.html
      format.csv { send_data @members.to_csv }
    end
  end

  def invoices
  end

  private

    def set_space
      if params[:space_id].blank?
        @space = current_user.default_space
        redirect_to space_members_path(@space)
      else
        @space = current_user.spaces.friendly.find(params[:space_id])
      end

    end
end
