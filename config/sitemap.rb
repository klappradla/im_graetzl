# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://www.imgraetzl.at'
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using aws-sdk
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV['UPLOADS_BUCKET'], path: 'sitemaps/')

SitemapGenerator::Sitemap.create do
  # Districts
  add wien_path, changefreq: 'always', priority: 0.9
  add locations_wien_path, changefreq: 'always', priority: 0.7
  add meetings_wien_path, changefreq: 'always', priority: 0.7
  add rooms_wien_path, changefreq: 'always', priority: 0.9
  add zuckerls_wien_path, changefreq: 'always', priority: 0.7
  District.find_each do |district|
    add district_path(district), changefreq: 'always', priority: 0.8
    add locations_district_path(district) unless district.locations.empty?, changefreq: 'always', priority: 0.8
    add meetings_district_path(district) unless district.meetings.empty?, changefreq: 'always', priority: 0.7
    add rooms_district_path(district), changefreq: 'always', priority: 0.8
  end

  # Graetzls
  Graetzl.find_each do |graetzl|
    add graetzl_path(graetzl), changefreq: 'always', priority: 0.7

    # Locations
    locations = graetzl.locations.approved
    unless locations.empty?
      add locations_graetzl_path(graetzl)
      locations.find_each do |location|
        add graetzl_location_path(graetzl, location), priority: 0.8
      end
    end

    # Meetings
    meetings = graetzl.meetings.active
    unless meetings.empty?
      add meetings_graetzl_path(graetzl)
      meetings.find_each do |meeting|
        add graetzl_meeting_path(graetzl, meeting), priority: 0.7
      end
    end
  end

  # Raumteiler
  RoomOffer.find_each do |room_offer|
    add room_offer_path(room_offer), priority: 0.8
  end

  RoomDemand.find_each do |room_demand|
    add room_demand_path(room_demand), priority: 0.8
  end

  RoomCall.find_each do |room_call|
    add room_call_path(room_call), priority: 0.8
  end

  # Info Pages
  add info_agb_path, changefreq: 'never', priority: 0.3
  add info_datenschutz_path, changefreq: 'never', priority: 0.3
  add info_impressum_path, changefreq: 'never', priority: 0.3
  add info_infos_zum_graetzlzuckerl_path, changefreq: 'never', priority: 0.3
  add info_fragen_und_antworten_path, changefreq: 'never', priority: 0.3
  add info_infos_zur_graetzlmarie_path, changefreq: 'never', priority: 0.3

  # Registration (only get paths)
  add new_user_session_path, changefreq: 'never', priority: 0.3
  add new_password_path, changefreq: 'never', priority: 0.3
  add edit_password_path, changefreq: 'never', priority: 0.3
  add new_confirmation_path, changefreq: 'never', priority: 0.3
  add new_registration_path, changefreq: 'never', priority: 0.3
end
