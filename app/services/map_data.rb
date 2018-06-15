class MapData < BaseService
  def initialize(districts:nil, district:nil, graetzls:nil, graetzl:nil, addresses:nil, address:nil)
    districts = [districts, district].flatten.compact
    graetzls = [graetzls, graetzl].flatten.compact
    addresses = [addresses, address].flatten.compact

    # want to end up with two only collections here
    @districts = districts.empty? ? nil : districts
    @graetzls = graetzls.empty? ? nil : graetzls
    @addresses = addresses.empty? ? nil : addresses
  end

  def call
    map_hash.to_json
  end

  private

  attr_reader :districts, :graetzls

  def map_hash
    [district_data, graetzl_data, address_data].inject(:merge)
  end

  def district_data
    return {} unless @districts
    { districts: encode(@districts) }
  end

  def graetzl_data
    return {} unless @graetzls
    { graetzls: encode(@graetzls) }
  end
  
  def address_data
    Rails.logger.info "Person attributes hash: #{@addresses}"
    return {} unless @addresses
    { addresses: encode(@addresses) }
  end

  def encode(collection)
    features = collection.map{ |item| feature item }
    feature_collection = factory.feature_collection features
    RGeo::GeoJSON.encode feature_collection
  end

  def feature(item)
    # graetzls/districts have area, addresses have coordinates
    geometry = item.try(:area) || item.try(:coordinates)
    factory.feature(geometry, item.id, properties(item))
  end

  def properties(item)
    begin
      targetURL = polymorphic_path(item)
    rescue
      targetURL = nil
    end
    { name: item.try(:name), zip: item.try(:zip), targetURL: targetURL }
  end

  def factory
    @factory ||= RGeo::GeoJSON::EntityFactory.new
  end
end
