def asset_url(resource, asset_name)
  host = "https://#{Refile.cdn_host || @request.host}"
  Refile.attachment_url(resource, asset_name, host: host)
end

collection @users
attributes :id,
  :username,
  :role,
  :created_at,
  :last_sign_in_at,
  :slug,
  :first_name,
  :last_name,
  :email,
  :newsletter,
  :website,
  :newsletter,
  :graetzl_id,
  :avatar do |u|
    #asset_url(u.avatar, :avatar)
    Refile.attachment_url(u, :avatar, :fill, 400, 400, host: request.url)
  end
