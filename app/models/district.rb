class District < ApplicationRecord
  extend FriendlyId
  friendly_id :long_name

  has_many :district_graetzls
  has_many :graetzls, through: :district_graetzls

  has_many :locations, through: :graetzls
  has_many :meetings, through: :graetzls
  has_many :curators, through: :graetzls
  has_many :room_offers, through: :graetzls
  has_many :room_demands, -> { distinct }, through: :graetzls
  has_many :groups, -> { distinct }, through: :graetzls

  MEMOIZED = includes(:graetzls).map{|d| [d.id, d] }.to_h.freeze

  def self.memoized(id)
    MEMOIZED[id]
  end

  def long_name
    "#{name}-#{zip}"
  end

  def zip_name
    "#{zip} – #{name}"
  end

  def numeric
    zip.slice(1..2).sub(%r{^0},"") if zip.present?
  end

  def zuckerls
    @zuckerls ||= Zuckerl.live.where(location_id: locations.map(&:id))
  end
end
