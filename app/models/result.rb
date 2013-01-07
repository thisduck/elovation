class Result < ActiveRecord::Base
  has_and_belongs_to_many :players
  belongs_to :winner, :class_name => "Player"
  belongs_to :loser, :class_name => "Player"
  belongs_to :league

  scope :most_recent_first, :order => "created_at desc"
  scope :for_league, lambda { |league| where(:league_id => league.id) }

  validates_presence_of :winner
  validates_presence_of :loser

  validate do |result|
    if result.winner == result.loser and not result.winner.nil?
      errors.add(:base, "Winner and loser can't be the same player")
    end
  end

  def as_json(options = {})
    {
      :winner => winner.name,
      :loser => loser.name,
      :created_at => created_at.utc.to_s
    }
  end

  def most_recent?
    players.all? do |player|
      player.results.where(:league_id => league.id).order("created_at DESC").first == self
    end
  end
end
