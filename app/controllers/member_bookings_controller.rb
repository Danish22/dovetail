#
# Members view of bookable meeting rooms
#
class MemberBookingsController < PortalApplicationController

  before_action :set_meetingroom
  before_action :set_booking, only: [:edit, :update, :destroy]

  def new
    @booking =  @meetingroom.bookings.new  # Not quite right, but never called.
  end

  def edit
  end

  def create
    Time.use_zone(@meetingroom.location.timezone) do

      @booking =  @meetingroom.bookings.new(booking_params)
      
      @booking.member = current_member
      @booking.space = @space
      @booking.location = @meetingroom.location
      
      respond_to do |format|
        if @booking.save
          format.html { redirect_to member_room_path(@meetingroom), notice: 'Booking was successfully created.' }
          format.json { render :show, status: :created, location: member_room_path(@meetingroom) }
        else
          format.html { render :new }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    Time.use_zone(@meetingroom.location.timezone) do
      respond_to do |format|
        if @booking.update(booking_params)
          format.html { redirect_to member_room_path(@meetingroom), notice: 'Booking was successfully updated.' }
          format.json { render :show, status: :ok, location: member_room_path(@meetingroom)}
        else
          format.html { render :edit }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to member_room_path(@meetingroom), notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_meetingroom
      @meetingroom = @space.meetingrooms.find(params[:member_room_id])
    end

    def set_booking
      @booking = current_member.bookings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:starting, :ending)
    end

end
