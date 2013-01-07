class PlayerLeaguesController < ApplicationController
  def show
    @player = Player.find(params[:player_id])
    @league = League.find(params[:id])
  end
end
