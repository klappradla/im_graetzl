collection @users
attributes :id,
  :username,
  :role,
  :created_at,
  #:last_sign_in_at,
  :slug,
  :first_name,
  :last_name,
  :email,
  #:newsletter,
  #:website,
  :graetzl_id

node :avatar do |u|
  Refile.attachment_url(u, :avatar, :fill, 400, 400)
end
