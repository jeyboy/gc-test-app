class Agency::TripsController < Agency::BaseController
  layout 'agency'

  def update
    @trip = current_agency.trips.find(params[:id])
    done = @trip.update_attributes(params[:trip])   
    validate_done(done)
  end

  def edit
    @trip = Trip.find(params[:id])
    render 'new'
  end

  def show
    @trip = Trip.
      includes(:users, :agency, :packages, :addons, :payments, :deadlines).
      find(params[:id])
  end
end
