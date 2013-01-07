class DashboardController < ApplicationController
  def show
    @players = Player.all
    @leagues = League.all
  end
end
