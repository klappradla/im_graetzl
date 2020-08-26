class RoomRentalAvailability

  def initialize(room_offer)
    @room_offer = room_offer
  end

  def available_hours(date, hour_from)
    date = date.is_a?(String) ? Date.parse(date) : date
    hour_from = hour_from.present? ? hour_from.to_i : nil

    if !initial_availablity.day_enabled?(date.wday)
      return []
    end

    from_list = initial_availablity.available_hour_list(date.wday)

    taken_slots(date).each do |slot|
      from_list -= slot.hour_list
    end

    to_list = from_list.map{|h| h + 1}
    if hour_from.present?
      min_to = hour_from + minimum_rental_hours
      max_to = taken_slots(date).select{|s| s.hour_from > hour_from}.map(&:hour_from).min || 24
      to_list.select!{|h| h.between?(min_to, max_to)}
    end

    {
      from: from_list,
      to: to_list,
    }
  end

  def timetable(date)
    if !initial_availablity.day_enabled?(date.wday)
      return [[:disabled, 24]]
    end
    schedule = []
    schedule << [:disabled, initial_availablity.from(date.wday)]
    previous_hour = initial_availablity.from(date.wday)
    active_slots(date).includes(room_rental: :user_message_thread).sort_by(&:hour_from).each do |slot|
      schedule << [:available, slot.hour_from - previous_hour]
      schedule << [slot.room_rental, slot.hours]
      previous_hour = slot.hour_to
    end
    schedule << [:available, initial_availablity.to(date.wday) - previous_hour]
    schedule << [:disabled, 24 - initial_availablity.to(date.wday)]
    schedule.reject{|_, length| length.zero? }
  end

  private

  def initial_availablity
    @room_offer.room_offer_availability
  end

  def minimum_rental_hours
    @room_offer.room_rental_price.minimum_rental_hours || 1
  end

  def taken_slots(date)
    rentals = @room_offer.room_rentals.approved
    RoomRentalSlot.where(room_rental_id: rentals.pluck(:id), rent_date: date)
  end

  def active_slots(date)
    rentals = @room_offer.room_rentals.where(rental_status: [:pending, :approved])
    RoomRentalSlot.where(room_rental_id: rentals.pluck(:id), rent_date: date)
  end

end
