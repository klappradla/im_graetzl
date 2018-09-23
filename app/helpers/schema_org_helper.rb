module SchemaOrgHelper

  def structured_data_tag (type, object)
    hash = {:@context => 'http://www.schema.org'}
    final_hash = hash.merge(structured_data_meeting(object)) if type == 'meeting'
    final_hash = hash.merge(structured_data_location(object)) if type == 'location'
    content_tag(:script, final_hash.to_json, {type: 'application/ld+json'}, false) # false is used here to prevent html character escaping
  end

  # Create Structured Data for Meetings
  def structured_data_meeting (meeting)
    hash = {:@type => 'Event'}
    hash[:name] = meeting.name
    hash[:description] = meeting.description
    hash[:startDate] = I18n.localize(meeting.starts_at_date, format:'%Y-%m-%d') if meeting.starts_at_date
    hash[:image] = attachment_url(meeting, :cover_photo, host: request.url, fallback: 'meta/og_logo.png')
    hash[:url] = meeting_url(meeting)

    hash[:location] = {:@type => 'Place'} # Object for Event Location or Address
    if !meeting.address.nil? # Take Adress from Meeting if exists
      hash[:location][:address] = structured_data_address(meeting.address)
      hash[:location][:name] = meeting.address.description if meeting.address.description.present?
    end

    if meeting.location # If Location exists
      hash[:location][:name] = meeting.location.name
      hash[:location][:image] = attachment_url(meeting.location, :cover_photo, host: request.url, fallback: 'meta/og_logo.png')
      hash[:location][:sameAs] = location_url(meeting.location)
      # Take Address from Location if no Meeting Address exists
      if meeting.address.nil? && meeting.location.address
        hash[:location][:address] = structured_data_address(meeting.location.address)
      end
    end

    if !meeting.initiator.nil? # Creator of Meeting
      hash[:organizer] = structured_data_person(meeting.initiator)
    end

    return hash
  end

  # Create Structured Data for Locations
  def structured_data_address (address)
    hash = {:@type => 'PostalAddress'}
    hash[:streetAddress] = address.street if address.street
    hash[:addressLocality] = address.city if address.city
    hash[:addressRegion] = address.city if address.city
    hash[:postalCode] = address.zip if address.zip
    hash[:addressCountry] = 'AT'
    return hash
  end

  # Create Structured Data for Persons
  def structured_data_person (user)
    hash = {:@type => 'Person'}
    hash[:name] = user.full_name
    hash[:image] = attachment_url(user, :avatar, host: request.url, fallback: 'meta/og_logo.png')
    return hash
  end

  # Create Structured Data for Locations
  def structured_data_location (location)
    hash = {:@type => 'LocalBusiness'}
    hash[:name] = location.name
    hash[:description] = location.slogan if location.slogan.present?
    hash[:url] = location_url(location)
    hash[:logo] = attachment_url(location, :avatar, host: request.url, fallback: 'avatar/location/400x400.png')
    hash[:image] = attachment_url(location, :cover_photo, host: request.url, fallback: 'meta/og_logo.png')
    hash[:email] = location.contact.email if location.contact.email.present?
    hash[:telephone] = location.contact.phone if location.contact.phone.present?
    hash[:address] = structured_data_address(location.address) if location.address
    if location.address.try(:coordinates)
      hash[:geo] = {:@type => 'GeoCoordinates'}
      hash[:geo][:latitude] = location.address.coordinates.y
      hash[:geo][:longitude] = location.address.coordinates.x
    end
    return hash
  end

end
