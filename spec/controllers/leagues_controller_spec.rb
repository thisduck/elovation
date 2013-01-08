require "spec_helper"

describe LeaguesController do
  
  let(:admin) { FactoryGirl.create :admin}
  before { controller.stubs(:current_player).returns(admin) }
  
  describe "new" do
    it "exposes a new league" do
      get :new

      assigns(:league).should_not be_nil
    end
  end

  describe "edit" do
    it "exposes the league for editing" do
      league = FactoryGirl.create(:league)

      get :edit, :id => league

      assigns(:league).should == league
    end
  end

  describe "create" do
    context "with valid params" do
      it "creates a league" do
        post :create, :league => {:name => "Go"}

        League.where(:name => "Go").first.should_not be_nil
      end

      it "redirects to the league's show page" do
        post :create, :league => {:name => "Go"}

        league = League.where(:name => "Go").first

        response.should redirect_to(league_path(league))
      end

      it "protects against mass assignment" do
        Timecop.freeze(Time.now) do
          post :create, :league => {:created_at => 3.days.ago, :name => "Go"}

          league = League.where(:name => "Go").first
          league.created_at.should > 3.days.ago
        end
      end
    end

    context "with invalid params" do
      it "renders new given invalid params" do
        post :create, :league => {:name => nil}

        response.should render_template(:new)
      end
    end
  end

  describe "destroy" do
    it "allows deleting leagues without results" do
      league = FactoryGirl.create(:league, :name => "First name")

      delete :destroy, :id => league

      response.should redirect_to(dashboard_path)
      League.find_by_id(league.id).should be_nil
    end

    it "doesn't allow deleting leagues with results" do
      league = FactoryGirl.create(:league, :name => "First name")
      FactoryGirl.create(:result, :league => league)

      delete :destroy, :id => league

      response.should redirect_to(dashboard_path)
      League.find_by_id(league.id).should == league
    end
  end

  describe "update" do
    context "with valid params" do
      it "redirects to the league's show page" do
        league = FactoryGirl.create(:league, :name => "First name")

        put :update, :id => league, :league => {:name => "Second name"}

        response.should redirect_to(league_path(league))
      end

      it "updates the league with the provided attributes" do
        league = FactoryGirl.create(:league, :name => "First name")

        put :update, :id => league, :league => {:name => "Second name"}

        league.reload.name.should == "Second name"
      end

      it "protects against mass assignment" do
        Timecop.freeze(Time.now) do
          league = FactoryGirl.create(:league, :name => "First name")

          put :update, :id => league, :league => {:created_at => 3.days.ago}

          league.created_at.should > 3.days.ago
        end
      end
    end

    context "with invalid params" do
      it "renders the edit page" do
        league = FactoryGirl.create(:league, :name => "First name")

        put :update, :id => league, :league => {:name => nil}

        response.should render_template(:edit)
      end
    end
  end

  describe "show" do
    it "exposes the league" do
      league = FactoryGirl.create(:league)

      get :show, :id => league

      assigns(:league).should == league
    end

    it "returns a json response" do
      Timecop.freeze(Time.now) do
        league = FactoryGirl.create(:league)

        player1 = FactoryGirl.create(:player)
        player2 = FactoryGirl.create(:player)
        player3 = FactoryGirl.create(:player)

        rating1 = FactoryGirl.create(:rating, :league => league, :value => 1003, :player => player1)
        rating2 = FactoryGirl.create(:rating, :league => league, :value => 1002, :player => player2)
        rating3 = FactoryGirl.create(:rating, :league => league, :value => 1001, :player => player3)

        result1 = FactoryGirl.create(:result, :league => league, :winner => player1, :loser => player2)
        result2 = FactoryGirl.create(:result, :league => league, :winner => player2, :loser => player3)
        result3 = FactoryGirl.create(:result, :league => league, :winner => player3, :loser => player1)

        get :show, :id => league, :format => :json

        json_data = JSON.parse(response.body)
        json_data.should == {
          "name" => league.name,
          "ratings" => [
            {"player" => {"name" => player1.name, "email" => player1.email}, "value" => 1003},
            {"player" => {"name" => player2.name, "email" => player2.email}, "value" => 1002},
            {"player" => {"name" => player3.name, "email" => player3.email}, "value" => 1001}
          ],
          "results" => [
            {"winner" => player1.name, "loser" => player2.name, "created_at" => Time.now.utc.to_s},
            {"winner" => player2.name, "loser" => player3.name, "created_at" => Time.now.utc.to_s},
            {"winner" => player3.name, "loser" => player1.name, "created_at" => Time.now.utc.to_s}
          ]
        }
      end
    end
  end
end
