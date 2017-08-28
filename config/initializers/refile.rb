require 'refile/s3'

if Rails.env.production? || Rails.env.staging?

  aws = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region: 'eu-central-1',
    bucket: ENV['UPLOADS_BUCKET']
  }
  Refile.cache = Refile::S3.new(prefix: 'refile/cache', **aws)
  Refile.store = Refile::S3.new(prefix: 'refile/store', **aws)
  Refile.cdn_host = ENV['UPLOADS_CDN']

end
