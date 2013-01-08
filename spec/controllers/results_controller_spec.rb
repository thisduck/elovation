require "spec_helper"

describe ResultsController do
  
  let(:admin) { FactoryGirl.create :admin}
  before { controller.stubs(:current_player).returns(admin) }
  
  describe "new" do
    it "exposes a new result" do
      league = FactoryGirl.create(:league)

      get :new, :league_id => league

      assigns(:result).should_not be_nil
    end

    it "exposes the league" do
      league = FactoryGirl.create(:league)

      get :new, :league_id => league

      assigns(:league).should == league
    end
  end

  describe "create" do
    context "with valid params" do
      it "creates a new result with the given players" do
        league = FactoryGirl.create(:league, :results => [])
        player_1 = FactoryGirl.create(:player)
        player_2 = FactoryGirl.create(:player)
        controller.stubs(:current_player).returns(player_2)
        post :create, :league_id => league, :result => {
          :winner_id => player_1.id,
          :loser_id => player_2.id
        }

        result = league.reload.results.first

        result.should_not be_nil
        result.players.map(&:id).sort.should == [player_1.id, player_2.id].sort
        result.winner.should == player_1
        result.loser.should == player_2
      end
    end

    context "with invalid params" do
      it "renders the new page" do
        league = FactoryGirl.create(:league, :results => [])
        player = FactoryGirl.create(:player)
        controller.stubs(:current_player).returns(player)
        post :create, :league_id => league, :result => {
          :winner_id => player.id,
          :loser_id => player.id
        }

        response.should render_template(:new)
      end
    end
  end

  describe "destroy" do
    context "the most recent result for each player" do
      it "destroys the result and resets the elo for each player" do
        league = FactoryGirl.create(:league, :results => [])
        player_1 = FactoryGirl.create(:player)
        player_2 = FactoryGirl.create(:player)

        ResultService.create(league, :winner_id => player_1.id, :loser_id => player_2.id).result

        player_1_rating = player_1.ratings.where(:league_id => league.id).first
        player_2_rating = player_2.ratings.where(:league_id => league.id).first

        old_rating_1 = player_1_rating.value
        old_rating_2 = player_2_rating.value

        result = ResultService.create(league, :winner_id => player_1.id, :loser_id => player_2.id).result

        player_1_rating.reload.value.should_not == old_rating_1
        player_2_rating.reload.value.should_not == old_rating_2

        request.env['HTTP_REFERER'] = league_path(league)

        delete :destroy, :league_id => league, :id => result

        response.should redirect_to(league_path(league))

        player_1_rating.reload.value.should == old_rating_1
        player_2_rating.reload.value.should == old_rating_2

        player_1.reload.results.size.should == 1
        player_2.reload.results.size.should == 1
      end
    end
  end
end
