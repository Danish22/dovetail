class LocationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_space
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = @space.locations.all
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = @space.locations.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = @space.locations.new(location_params)

    respond_to do |format|
      if @location.save
        update_subscription_quantity 
        format.html { redirect_to [@space, @location], notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to [@space, @location], notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    update_subscription_quantity 
    respond_to do |format|
      format.html { redirect_to space_locations_url(@space), notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = @space.locations.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :city, :state, :postal_code, :country, :timezone, :currency, :tax_rate)
    end

    # Because we meter on locations, we need to update the subscription when ever one is added or removed.
    def update_subscription_quantity
      # TODO Make this asyncronous/background
      if @space.payment_method   # Only if they've subscribed (ie not trialing)
        @space.payment_method.update_subscription(@space, nil)
      end
    end
end
