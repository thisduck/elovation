require "spec_helper"

describe PlayerLeaguesController do
  describe "show" do
    it "renders successfully with the player and the league" do
      league = FactoryGirl.create(:league)
      player = FactoryGirl.create(:player)

      get :show, :player_id => player, :id => league
      response.should be_success

      assigns(:league).should == league
      assigns(:player).should == player
    end
  end
end
