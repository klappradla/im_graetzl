class RoomRentalTimetable

  def initialize(room_offer)
    @room_offer = room_offer
  end

  def schedule(date)
    if !initial_availablity.day_enabled?(date.wday)
      return [[:disabled, 24]]
    end
    schedule = []
    schedule << [:disabled, initial_availablity.from(date.wday)]
    previous_hour = initial_availablity.from(date.wday)
    @room_offer.active_rental_slots.includes(room_rental: :user_message_thread).select{|s| s.rent_date == date }.sort_by(&:hour_from).each do |slot|
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

end
