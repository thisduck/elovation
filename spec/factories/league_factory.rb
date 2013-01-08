FactoryGirl.define do
  factory :league do
    name { Faker::Lorem.words(1).first.capitalize }
    result_rule 'any_user'
  end
end
