require 'httparty'

namespace :db do
  desc 'import graetzls from mapbox api'
  task import_graetzls: :environment do

    def query_api
      access_token = 'pk.eyJ1IjoibWFsYW5vNzgiLCJhIjoiY2tnMjBmcWpwMG1sNjJ4cXdoZW9iMWM5NyJ9.z-AgKIQ_Op1P4aeRh_lGJw'
      map_id = 'ckh0g7hga08kl26o5b1tu57nz'
      query = "https://api.mapbox.com/datasets/v1/malano78/#{map_id}/features?access_token=#{access_token}"
      uri = URI.parse(URI.encode(query))
      HTTParty.get uri
    rescue HTTParty::Error
      nil
    end

    def parse_features(geojson)
      features = JSON.parse(geojson.body)['features']
      features.each do |feature|
        if feature['geometry'].present?
          area = RGeo::GeoJSON.decode(feature['geometry'], json_parser: :json)
          name = feature['properties']['title']
          graetzl = Graetzl.find_or_create_by(name: name, area: area)
        end
      end
    end

    api_response = query_api
    if api_response
      parse_features api_response
    else
      puts 'Cannot import graetzls from api'
    end
  end
end
