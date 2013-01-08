require "spec_helper"

describe Player do
  describe "as_json" do
    it "returns the json representation of the player" do
      player = FactoryGirl.build(:player, :name => "John Doe", :email => "foo@example.com")

      player.as_json.should == {
        :name => "John Doe",
        :email => "foo@example.com"
      }
    end
  end
  describe "validations" do
    context "name" do
      it "is required" do
        player = FactoryGirl.build(:player, :name => nil)

        player.should_not be_valid
        player.errors[:name].should == ["can't be blank"]
      end

      it "must be unique" do
        FactoryGirl.create(:player, :name => "Drew")
        player = FactoryGirl.build(:player, :name => "Drew")

        player.should_not be_valid
        player.errors[:name].should == ["has already been taken"]
      end
    end

    context "email" do
      it "must be a valid email format" do
        player = Player.new
        player.email = "invalid-email-address"
        player.should_not be_valid
        player.errors[:email].should == ["is invalid"]
        player.email = "valid@example.com"
        player.valid?
        player.errors[:email].should == []
      end
    end
  end

  describe "name" do
    it "has a name" do
      player = FactoryGirl.create(:player, :name => "Drew")

      player.name.should == "Drew"
    end
  end

  describe "recent_results" do
    it "returns 5 of the player's results" do
      league = FactoryGirl.create(:league)
      player = FactoryGirl.create(:player)

      10.times { FactoryGirl.create(:result, :league => league, :winner => player) }

      player.recent_results.size.should == 5
    end

    it "returns the 5 most recently created results" do
      newer_results = nil
      league = FactoryGirl.create(:league)
      player = FactoryGirl.create(:player)

      Timecop.freeze(3.days.ago) do
        5.times.map { FactoryGirl.create(:result, :league => league, :winner => player) }
      end

      Timecop.freeze(1.day.ago) do
        newer_results = 5.times.map { FactoryGirl.create(:result, :league => league, :winner => player) }
      end

      player.recent_results.sort.should == newer_results.sort
    end

    it "orders results by created_at, descending" do
      league = FactoryGirl.create(:league)
      player = FactoryGirl.create(:player)
      old = new = nil

      Timecop.freeze(2.days.ago) do
        old = FactoryGirl.create(:result, :league => league, :winner => player)
      end

      Timecop.freeze(1.days.ago) do
        new = FactoryGirl.create(:result, :league => league, :winner => player)
      end

      player.recent_results.should == [new, old]
    end
  end

  describe "destroy" do
    it "deletes related ratings and results" do
      player = FactoryGirl.create(:player)
      rating = FactoryGirl.create(:rating, :player => player)
      result = FactoryGirl.create(:result, :winner => player)

      player.destroy

      Rating.find_by_id(rating.id).should be_nil
      Result.find_by_id(result.id).should be_nil
    end
  end

  describe "ratings" do
    describe "find_or_create" do
      it "returns the rating if it exists" do
        player = FactoryGirl.create(:player)
        league = FactoryGirl.create(:league)
        rating = FactoryGirl.create(:rating, :league => league, :player => player)

        expect do
          found_rating = player.ratings.find_or_create(league)
          found_rating.should == rating
        end.to_not change { player.ratings.count }
      end

      it "creates a rating and returns it if it doesn't exist" do
        player = FactoryGirl.create(:player)
        league = FactoryGirl.create(:league)

        expect do
          player.ratings.find_or_create(league).should_not be_nil
        end.to change { player.ratings.count }.by(1)
      end
    end
  end

  describe "rewind_rating!" do
    it "resets the player's rating to the previous rating" do
      player = FactoryGirl.create(:player)
      league = FactoryGirl.create(:league)
      rating = FactoryGirl.create(:rating, :league => league, :player => player, :value => 1002)
      FactoryGirl.create(:rating_history_event, :rating => rating, :value => 1001)
      FactoryGirl.create(:rating_history_event, :rating => rating, :value => 1002)

      player.rewind_rating!(league)

      player.ratings.where(:league_id => league.id).first.value.should == 1001
    end
  end

  describe "wins" do
    it "finds wins" do
      player = FactoryGirl.create(:player)
      league = FactoryGirl.create(:league)
      win = FactoryGirl.create(:result, :league => league, :winner => player)
      loss = FactoryGirl.create(:result, :league => league, :loser => player)
      player.results.for_league(league).size.should == 2
      player.results.for_league(league).wins.should == [win]
    end
  end

  describe "losses" do
    it "finds losses" do
      player = FactoryGirl.create(:player)
      league = FactoryGirl.create(:league)
      win = FactoryGirl.create(:result, :league => league, :winner => player)
      loss = FactoryGirl.create(:result, :league => league, :loser => player)
      player.results.for_league(league).size.should == 2
      player.results.for_league(league).losses.should == [loss]
    end
  end

  describe "against" do
    it "finds results against a specific opponent" do
      player = FactoryGirl.create(:player)
      league = FactoryGirl.create(:league)
      opponent1 = FactoryGirl.create(:player)
      opponent2 = FactoryGirl.create(:player)
      win_against_opponent1 = FactoryGirl.create(:result, :league => league, :winner => player, :loser => opponent1)
      loss_against_opponent1 = FactoryGirl.create(:result, :league => league, :winner => opponent1, :loser => player)
      win_against_opponent2 = FactoryGirl.create(:result, :league => league, :winner => player, :loser => opponent2)
      opponent2_league_against_different_player = FactoryGirl.create(:result, :league => league, :winner => FactoryGirl.create(:player), :loser => opponent2)
      player.results.for_league(league).against(opponent1).sort_by(&:id).should == [win_against_opponent1, loss_against_opponent1]
      player.results.for_league(league).against(opponent2).sort_by(&:id).should == [win_against_opponent2]
    end
  end
end
