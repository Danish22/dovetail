#
# Members view of bookable meeting rooms
#
class MemberRoomsController < PortalApplicationController

  before_action :set_meetingroom, only: [:show]

  def index
    if current_member
      @meetingrooms = @space.meetingrooms.all
    else
      @meetingrooms = []
    end
  end

  def show
    Time.use_zone(@meetingroom.location.timezone) do
      @bookings = @meetingroom.bookings.where("ending >= ?", Time.now.in_time_zone(@meetingroom.location.timezone)).order("starting asc").all
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_meetingroom
      @meetingroom = @space.meetingrooms.find(params[:id])
    end

end

