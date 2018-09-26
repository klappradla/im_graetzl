module SchemaOrgHelper

  def structured_data_tag (type, object)
    hash = {:@context => 'http://www.schema.org'}
    final_hash = hash.merge(structured_data_meeting(object)) if type == 'meeting'
    final_hash = hash.merge(structured_data_location(object)) if type == 'location'
    final_hash = hash.merge(structured_data_roomoffer(object)) if type == 'room_offer'
    content_for :structured_data_tag, content_tag(:script, final_hash.to_json, {type: 'application/ld+json'}, false) # false is used here to prevent html character escaping
  end

  # //////////////////////////// Create Structured Data for MEETINGS
  def structured_data_meeting (meeting)
    hash = {:@type => 'Event'}
    hash[:name] = meeting.name
    hash[:description] = meeting.description if meeting.description.present?
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

  # //////////////////////////// Create Structured Data for ADDRESS
  def structured_data_address (address)
    hash = {:@type => 'PostalAddress'}
    hash[:streetAddress] = address.street if address.street
    hash[:addressLocality] = address.city if address.city
    hash[:addressRegion] = address.city if address.city
    hash[:postalCode] = address.zip if address.zip
    hash[:addressCountry] = 'AT'
    return hash
  end

  # //////////////////////////// Create Structured Data for PERSONS
  def structured_data_person (user)
    hash = {:@type => 'Person'}
    hash[:name] = user.full_name
    hash[:image] = attachment_url(user, :avatar, host: request.url, fallback: 'meta/og_logo.png')
    return hash
  end

  # //////////////////////////// Create Structured Data for LOCATIONS
  def structured_data_location (location)
    hash = {:@type => 'LocalBusiness'}
    hash[:name] = location.name + ' - ' + location.slogan if location.slogan.present?
    hash[:description] = location.description if location.description.present?
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

  # //////////////////////////// Create Structured Data for ROOM_OFFERS
  def structured_data_roomoffer (room_offer)
    hash = {:@type => 'RentAction'}
    hash[:object] = {:@type => 'Room'}
    hash[:object][:name] = t("activerecord.attributes.room_offer.offer_types.#{@room_offer.offer_type}") + ': ' + room_offer.slogan
    hash[:object][:address] = structured_data_address(room_offer.address) if room_offer.address
    hash[:image] = attachment_url(room_offer, :cover_photo, host: request.url, fallback: 'meta/og_logo.png')
    hash[:landlord] = structured_data_person(room_offer.user) if room_offer.user
    hash[:landlord] = structured_data_location(room_offer.location)if room_offer.location
    return hash
  end

end
