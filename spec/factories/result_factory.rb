FactoryGirl.define do
  factory :result do
    league
    association :loser, :factory => :player
    association :winner, :factory => :player

    after(:build) do |result|
      result.players = [result.loser, result.winner]
    end
  end
end
