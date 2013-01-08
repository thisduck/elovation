class League < ActiveRecord::Base
  RESULT_RULES = %w(any_user any_participant winner loser)

  has_many :ratings, :dependent => :destroy
  has_many :results, :dependent => :destroy

  validates :name, :presence => true
  validates :result_rule, inclusion: {in: RESULT_RULES}

  def all_ratings
    ratings.order("value DESC")
  end

  def as_json(options = {})
    {
      :name => name,
      :ratings => top_ratings.map(&:as_json),
      :results => recent_results.map(&:as_json)
    }
  end

  def players
    ratings.map(&:player)
  end

  def recent_results
    results.order("created_at DESC").limit(5)
  end

  def top_ratings
    ratings.order("value DESC").limit(5)
  end

  def valid_result_poster?(result)
    case result_rule
      when 'any_user'
        true
      when 'any_participant'
        [result.winner, result.loser].include?(result.poster)
      when 'winner'
        result.winner == result.poster
      when 'loser'
        result.loser == result.poster
      else
        false
    end
  end
end
