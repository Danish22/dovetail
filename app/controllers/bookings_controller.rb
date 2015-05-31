class BookingsController < ApplicationController

  before_action :authenticate_user!

  before_action :set_space
  before_action :set_meetingroom

  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = @meetingroom.bookings.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking =  @meetingroom.bookings.new  # Not quite right, but never called.
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    Time.use_zone(@meetingroom.location.timezone) do

      @booking =  @meetingroom.bookings.new(booking_params)
      
      @booking.space = @space
      @booking.location = @meetingroom.location
      
      respond_to do |format|
        if @booking.save
          format.html { redirect_to [@space, @meetingroom], notice: 'Booking was successfully created.' }
          format.json { render :show, status: :created, location: [@space, @meetingroom] }
        else
          format.html { render :new }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    Time.use_zone(@meetingroom.location.timezone) do
      respond_to do |format|
        if @booking.update(booking_params)
          format.html { redirect_to [@space, @meetingroom], notice: 'Booking was successfully updated.' }
          format.json { render :show, status: :ok, location: [@space, @meetingroom] }
        else
          format.html { render :edit }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to [@space, @meetingroom], notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meetingroom
      @meetingroom = @space.meetingrooms.find(params[:meetingroom_id])
    end

    def set_booking
      @booking = @meetingroom.bookings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:member_id, :starting, :ending)
    end
end
