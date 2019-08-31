class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  before_save :get_coordinates

  def self.from_feature(feature)
    return nil if feature.blank?
    begin
      feature = JSON.parse(feature)
      new(
        coordinates: RGeo::GeoJSON.decode(feature['geometry'], json_parser: :json),
        street_name: feature['properties']['StreetName'],
        street_number: feature['properties']['StreetNumber'],
        zip: feature['properties']['PostalCode'],
        city: feature['properties']['Municipality']
      )
    rescue JSON::ParserError
      nil
    end
  end

  def graetzls
    Graetzl.where('ST_CONTAINS(area, :point)', point: coordinates)
  end

  def graetzl
    graetzls.first
  end

  def district_nr
    zip.slice(1..2).sub(%r{^0},"") unless zip.blank?
  end

  def street
    return nil if street_name.blank?
    "#{street_name} #{street_number}"
  end

  private

  def get_coordinates
    if street_name_changed? && street_name.present?
      self.coordinates = Coordinates.call(self)
    end
  end
end
