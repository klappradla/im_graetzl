collection @graetzls
attributes :id,
  :name,
  :users_count,
  :slug

child :districts, object_root: false do
  attributes :id, :name, :zip, :slug
end
