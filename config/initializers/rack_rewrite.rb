# Rack middleware to redirect urls with trailing slash
Rails.application.config.middleware.insert_before(0, Rack::Rewrite) do
  r301 %r{^/(.*)/$}, '/$1'
end
