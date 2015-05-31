class MeetingroomsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space

  before_action :set_meetingroom, only: [:show, :edit, :update, :destroy]

  # GET /meetingrooms
  # GET /meetingrooms.json
  def index
    @meetingrooms = @space.meetingrooms.all
  end

  # GET /meetingrooms/1
  # GET /meetingrooms/1.json
  def show
    Time.use_zone(@meetingroom.location.timezone) do
      @bookings = @meetingroom.bookings.where("ending >= ?", Time.now.in_time_zone(@meetingroom.location.timezone)).order("starting asc").all
    end
  end

  # GET /meetingrooms/new
  def new
    @meetingroom = @space.meetingrooms.new
  end

  # GET /meetingrooms/1/edit
  def edit
  end

  # POST /meetingrooms
  # POST /meetingrooms.json
  def create
    @meetingroom = @space.meetingrooms.new(meetingroom_params)
    @meetingroom.user = current_user

    respond_to do |format|
      if @meetingroom.save
        format.html { redirect_to [@space, @meetingroom], notice: 'Meetingroom was successfully created.' }
        format.json { render :show, status: :created, location: [@space, @meetingroom] }
      else
        format.html { render :new }
        format.json { render json: @meetingroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetingrooms/1
  # PATCH/PUT /meetingrooms/1.json
  def update
    respond_to do |format|
      if @meetingroom.update(meetingroom_params)
        format.html { redirect_to [@space, @meetingroom], notice: 'Meetingroom was successfully updated.' }
        format.json { render :show, status: :ok, location: [@space, @meetingroom] }
      else
        format.html { render :edit }
        format.json { render json: @meetingroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetingrooms/1
  # DELETE /meetingrooms/1.json
  def destroy
    @meetingroom.destroy
    respond_to do |format|
      format.html { redirect_to space_meetingrooms_url(@space), notice: 'Meetingroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meetingroom
      @meetingroom = @space.meetingrooms.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meetingroom_params
      params.require(:meetingroom).permit(:location_id, :name, :description)
    end
end
