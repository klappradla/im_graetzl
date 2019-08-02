class MeetingsSerializer

  def initialize(meetings, request)
    @meetings = meetings
    @request = request
  end

  def as_json(options = {})
    @meetings.map do |meeting|
      meeting.slice(
        :id,
        :name,
        :description,
        :created_at,
        :updated_at,
        :starts_at_date,
        :starts_at_time,
        :ends_at_date,
        :ends_at_time,
      ).merge(
        url: site_url(:graetzl_meeting_url, meeting.graetzl, meeting),
        cover_photo_url: asset_url(meeting, :cover_photo),
        graetzl: meeting.graetzl.name,
        graetzl_url: site_url(:graetzl_url, meeting.graetzl),
        location: location_fields(meeting.location),
        address: address_fields(meeting.display_address)
      )
    end
  end

  def location_fields(location)
    location.slice(:id, :name).merge(
      url: site_url(:graetzl_location_url, location.graetzl, location),
    ) if location
  end

  def address_fields(address)
    address.slice(
      :street_name, :street_number, :zip, :city
    ).merge(
      coordinates: coordinates_fields(address.coordinates)
    ) if address
  end

  def coordinates_fields(coordinates)
    {lat: coordinates.y, long: coordinates.x} if coordinates
  end

  def site_url(helper_name, *args)
    Rails.application.routes.url_helpers.public_send(helper_name, *args,
      protocol: @request.protocol, host: @request.host, port: @request.port )
  end

  def asset_url(resource, asset_name)
    host = "https://#{Refile.cdn_host || @request.host}"
    Refile.attachment_url(resource, asset_name, host: host)
  end
end
