FactoryGirl.define do
  factory :rating do
    league
    player
    pro false
    value Rating::DefaultValue
  end
end
