class Player < ActiveRecord::Base
  has_many :ratings, :order => "value DESC", :dependent => :destroy do
    def find_or_create(league)
      where(:league_id => league.id).first || create(:league => league, :value => Rating::DefaultValue, :pro => false)
    end
  end

  has_and_belongs_to_many :results do
    def against(opponent)
      player = proxy_association.owner.id
      where(
        [
          "(winner_id = ? and loser_id = ?) OR (winner_id = ? and loser_id = ?)",
          player, opponent, opponent, player
        ]
      )
    end

    def losses
      where(:loser_id => proxy_association.owner.id)
    end

    def wins
      where(:winner_id => proxy_association.owner.id)
    end
  end

  before_destroy do
    results.each { |result| result.destroy }
  end

  validates :name, :uniqueness => true, :presence => true
  validates :email, :format => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true

  def as_json
    {
      :name => name,
      :email => email
    }
  end

  def recent_results
    results.order("created_at DESC").limit(5)
  end

  def rewind_rating!(league)
    rating = ratings.where(:league_id => league.id).first
    rating.rewind!
  end
end
