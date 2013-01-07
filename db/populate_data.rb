players = 5.times.map { FactoryGirl.create(:player) }
leagues = 5.times.map { FactoryGirl.create(:league) }

leagues.each do |league|
  3.times do
    winner = players[rand(5)]
    loser = players.reject { |p| p == winner }[rand(4)]

    ResultService.create(league, :winner_id => winner.id, :loser_id => loser.id)
  end
end
