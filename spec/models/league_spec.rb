require "spec_helper"

describe League do
  describe "name" do
    it "has a name" do
      league = FactoryGirl.create(:league, :name => "Go")

      league.name.should == "Go"
    end
  end

  describe "players" do
    it "returns players who have a rating for the league" do
      league = FactoryGirl.create(:league)
      player1 = FactoryGirl.create(:player)
      player2 = FactoryGirl.create(:player)
      FactoryGirl.create(:rating, :league => league, :player => player1)
      FactoryGirl.create(:rating, :league => league, :player => player2)
      league.players.sort_by(&:id).should == [player1, player2]
    end
  end

  describe "recent results" do
    it "returns 5 of the leagues results" do
      league = FactoryGirl.create(:league)
      10.times { FactoryGirl.create(:result, :league => league) }

      league.recent_results.size.should == 5
    end

    it "returns the 5 most recently created results" do
      newer_results = nil
      league = FactoryGirl.create(:league)

      Timecop.freeze(3.days.ago) do
        5.times.map { FactoryGirl.create(:result, :league => league) }
      end

      Timecop.freeze(1.day.ago) do
        newer_results = 5.times.map { FactoryGirl.create(:result, :league => league) }
      end

      league.recent_results.sort.should == newer_results.sort
    end

    it "orders results by created_at, descending" do
      league = FactoryGirl.create(:league)
      old = new = nil

      Timecop.freeze(2.days.ago) do
        old = FactoryGirl.create(:result, :league => league)
      end

      Timecop.freeze(1.days.ago) do
        new = FactoryGirl.create(:result, :league => league)
      end

      league.recent_results.should == [new, old]
    end
  end

  describe "top_ratings" do
    it "returns 5 ratings associated with the league" do
      league = FactoryGirl.create(:league)
      10.times { FactoryGirl.create(:rating, :league => league) }

      league.top_ratings.count.should == 5
    end

    it "orders ratings by value, descending" do
      league = FactoryGirl.create(:league)
      rating2 = FactoryGirl.create(:rating, :league => league, :value => 2)
      rating3 = FactoryGirl.create(:rating, :league => league, :value => 3)
      rating1 = FactoryGirl.create(:rating, :league => league, :value => 1)

      league.top_ratings.should == [rating3, rating2, rating1]
    end
  end

  describe "all_ratings" do
    it "orders all ratings by value, descending" do
      league = FactoryGirl.create(:league)
      rating2 = FactoryGirl.create(:rating, :league => league, :value => 2)
      rating3 = FactoryGirl.create(:rating, :league => league, :value => 3)
      rating1 = FactoryGirl.create(:rating, :league => league, :value => 1)
      rating4 = FactoryGirl.create(:rating, :league => league, :value => 4)
      rating5 = FactoryGirl.create(:rating, :league => league, :value => 5)
      rating6 = FactoryGirl.create(:rating, :league => league, :value => 6)

      league.all_ratings.should == [
        rating6,
        rating5,
        rating4,
        rating3,
        rating2,
        rating1
      ]
    end
  end

  describe "validations" do
    context "name" do
      it "must be present" do
        league = FactoryGirl.build(:league, :name => nil)

        league.should_not be_valid
        league.errors[:name].should == ["can't be blank"]
      end
    end
  end

  describe "destroy" do
    it "deletes related ratings and results" do
      league = FactoryGirl.create(:league)
      rating = FactoryGirl.create(:rating, :league => league)
      result = FactoryGirl.create(:result, :league => league)

      league.destroy

      Rating.find_by_id(rating.id).should be_nil
      Result.find_by_id(result.id).should be_nil
    end
  end
end
