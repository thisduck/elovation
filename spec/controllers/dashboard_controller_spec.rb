require "spec_helper"

describe DashboardController do
  describe "show" do
    it "displays all players and leagues" do
      player = FactoryGirl.create(:player)
      league = FactoryGirl.create(:league)

      get :show

      assigns(:players).should == [player]
      assigns(:leagues).should == [league]
    end
  end
end
