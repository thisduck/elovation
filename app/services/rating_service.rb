class RatingService
  def self.update(league, winner, loser)
    winner_rating = winner.ratings.find_or_create(league)
    loser_rating = loser.ratings.find_or_create(league)

    winner_elo = winner_rating.to_elo
    loser_elo = loser_rating.to_elo

    winner_elo.wins_from(loser_elo)

    _update_rating_from_elo(winner_rating, winner_elo)
    _update_rating_from_elo(loser_rating, loser_elo)
  end

  def self._update_rating_from_elo(rating, elo)
    Rating.transaction do
      rating.update_attributes!(:value => elo.rating, :pro => elo.pro?)
      rating.history_events.create!(:value => elo.rating)
    end
  end
end
