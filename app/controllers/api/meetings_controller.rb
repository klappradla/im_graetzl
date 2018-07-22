class Api::MeetingsController < Api::ApiController

  def index
    @meetings = Meeting.active.visible_to_all.where(approved_for_api: true)
    from_date, to_date = get_date_range
    if from_date || to_date
      @meetings = @meetings.where("starts_at_date >= ?", from_date) if from_date
      @meetings = @meetings.where("starts_at_date <= ?", to_date) if to_date
    else
      @meetings = @meetings.upcoming
    end

    @meetings = @meetings.includes(:graetzl, :address, location: [:address, :graetzl])

    render json: MeetingsSerializer.new(@meetings, request)
  end

  private

  def get_date_range
    from_date = Date.parse(params[:from_date]) if params[:from_date].present?
    to_date = Date.parse(params[:to_date]) if params[:to_date].present?
    return from_date, to_date
  end
end
