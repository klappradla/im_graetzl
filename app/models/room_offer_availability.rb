class RoomOfferAvailability < ApplicationRecord
  belongs_to :room_offer

  def self.fully_available
    attrs = (0..6).map{ |i| [["day_#{i}_from", 8], ["day_#{i}_to", 20]] }.flatten(1).to_h
    new(attrs)
  end

  def from(wday)
    read_attribute(:"day_#{wday}_from")
  end

  def to(wday)
    read_attribute(:"day_#{wday}_to")
  end

  def day_enabled?(wday)
    from(wday).present? && to(wday).present?
  end

end
