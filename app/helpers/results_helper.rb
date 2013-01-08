module ResultsHelper
  def player_options(reject_current = false)
    player_association = Player.order("name ASC")
    player_association = player_association.reject{|player| player == current_player} if reject_current
    player_association.map { |player| [player.name, player.id] }
  end
end
