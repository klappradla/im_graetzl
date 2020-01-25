module MeetingsHelper
  def meeting_past_flag(meeting)
    '-past' if meeting.try(:starts_at_date).try(:past?)
  end

  def meeting_link_text(meeting)
    meeting.try(:starts_at_date).try(:past?) ? 'Ansehen' : 'Mitmachen'
  end

  def address_value(address)
    address.try(:street)
  end

  def localize_time(time, format)
    if time
      I18n.localize(time, format: format)
    end
  end

  def meeting_place(meeting)
    meeting_map(meeting) + meeting_address(meeting)
  end

  def meeting_name(meeting)
    meeting.active? ? content_tag(:h1, meeting.name) : content_tag(:h2, 'ABGESAGT')
  end

  private

  def map_link(coords)
    "http://www.openstreetmap.org/?mlat=#{coords.y}&mlon=#{coords.x}&zoom=18"
  end

  def meeting_map(meeting)
    coords = meeting.display_address.try(:coordinates)
    if coords
      link_to map_link(coords), target: '_blank', class: 'iconMapLink' do
        icon_tag("map-location")
      end
    else
      content_tag(:div, icon_tag("map-location"), class: 'iconMapLink')
    end
  end

  def meeting_address(meeting)
    content_tag(:div, class: 'infotxt address') do
      location = meeting.location
      address = meeting.display_address
      case
      when address
        concat case
        when address.description.present?
          content_tag(:strong, address.description)
        when location
          link_to(location.name, [location.graetzl, location])
        end
        concat address.street
        concat tag(:br)
        concat "#{address.zip} #{address.city}"
      when location
        link_to(location.name, [location.graetzl, location])
      else
        content_tag(:strong, 'Ort steht noch nicht fest...')
      end
    end
  end
end
