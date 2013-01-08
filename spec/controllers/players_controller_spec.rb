require "spec_helper"

describe PlayersController do
  describe "show" do
    it "exposes the player" do
      player = FactoryGirl.create(:player)

      get :show, :id => player

      assigns(:player).should == player
    end
  end
end
