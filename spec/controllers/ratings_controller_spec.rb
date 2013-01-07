require "spec_helper"

describe RatingsController do
  describe "index" do
    it "renders ratins for the given league" do
      league = FactoryGirl.create(:league)
      rating = FactoryGirl.create(:rating, :league => league)

      get :index, :league_id => league

      assigns(:league).should == league
      response.should render_template(:index)
    end
  end
end
