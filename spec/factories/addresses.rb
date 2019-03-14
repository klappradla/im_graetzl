FactoryBot.define do
  factory :address do
    street_name { Faker::Address.street_name }
    street_number { Faker::Address.secondary_address }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    coordinates { "POINT (#{Faker::Address.longitude} #{Faker::Address.latitude})" }

    trait :esterhazygasse do
      street_name { 'Esterházygasse' }
      street_number { '5' }
      zip { '1060' }
      city { 'Wien' }
      coordinates { 'POINT (16.353172456228375 48.194235057984216)'}
    end

    trait :seestadt do
      street_name { 'Seestadtstraße' }
      city { 'Wien' }
      coordinates { 'POINT (16.508413324531308 48.219917789263086)' }
    end
  end
end
