module ResultsHelper
  def player_options
    Player.order("name ASC").reject{|player| player == current_player}.map { |player| [player.name, player.id] }
  end
end
