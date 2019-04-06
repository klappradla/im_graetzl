class MapData < BaseService

  RGEO_FACTORY = RGeo::GeoJSON::EntityFactory.new

  def for_graetzl(graetzl)
    { graetzls: graetzl_features(graetzl) }
  end

  def for_district(district)
    graetzls = District.memoized(district.id).graetzls
    { districts: district_feature(district), graetzls: graetzl_features(graetzls) }
  end

  def for_wien(districts)
    { districts: district_feature(districts) }
  end

  private

  def graetzl_features(graetzls)
    features = Array(graetzls).map { |g|
      RGEO_FACTORY.feature(g.area, g.id, {name: g.name, targetURL: graetzl_path(g)})
    }
    RGeo::GeoJSON.encode RGEO_FACTORY.feature_collection(features)
  end

  def district_feature(districts)
    features = Array(districts).map { |d|
      RGEO_FACTORY.feature(d.area, d.id, { name: d.name, zip: d.zip, targetURL: district_path(d) })
    }
    RGeo::GeoJSON.encode RGEO_FACTORY.feature_collection(features)
  end

end
