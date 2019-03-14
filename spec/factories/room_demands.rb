FactoryBot.define do
  factory :room_demand do
    slogan {"MyString"}
    needed_area {"9.99"}
    demand_description {"MyText"}
    personal_description {"MyText"}
    wants_collaboration {false}
    slug {"MyString"}
    user {nil}
  end
end
