class PlayersController < ApplicationController
  load_and_authorize_resource
  
  def show
  end

  def toggle_admin
    @player.toggle_admin!
    redirect_to root_url
  end
end
