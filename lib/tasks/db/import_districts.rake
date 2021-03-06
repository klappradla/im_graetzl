require 'httparty'

namespace :db do
  desc 'import districts from open gv api'
  task import_districts: :environment do

    def query_api
      query = 'https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:BEZIRKSGRENZEOGD&srsName=EPSG:4326&outputFormat=json'
      uri = URI.parse(URI.encode(query))
      HTTParty.get uri
    rescue HTTParty::Error
      nil
    end

    def parse_features(geojson)
      geojson['features'].each do |feature|
        area = RGeo::GeoJSON.decode(feature['geometry'], json_parser: :json)
        area = area.simplify(0.0001)
        name = feature['properties']['NAMEK']
        zip = feature['properties']['DISTRICT_CODE']
        District.find_or_create_by(name: name, zip: zip.to_s, area: area)
      end
    end

    api_response = query_api
    if api_response
      parse_features api_response
    else
      puts 'Cannot import districts from api'
    end
  end
end
