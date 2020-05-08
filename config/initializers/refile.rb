require 'refile/s3'

if Rails.env.production? || Rails.env.staging?

  aws = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION'],
    bucket: ENV['UPLOADS_BUCKET']
  }
  Refile.cache = Refile::S3.new(max_size: 5.megabytes, prefix: 'refile/cache', **aws)
  Refile.store = Refile::S3.new(max_size: 5.megabytes, prefix: 'refile/store', **aws)
  Refile.cdn_host = ENV['UPLOADS_CDN']

end
