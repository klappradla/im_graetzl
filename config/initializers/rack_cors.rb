Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  allow do
    origins /imgraetzl\.at(:\d+)?/
    resource '*', headers: :any, methods: [:get, :post, :options], credentials: true, max_age: 600
  end
end
