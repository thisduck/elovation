require "spec_helper"

describe RatingService do
  describe "update" do
    it "creates new ratings" do
      league = FactoryGirl.create(:league)
      player1 = FactoryGirl.create(:player)
      player2 = FactoryGirl.create(:player)

      RatingService.update(league, player1, player2)

      player1.ratings.where(:league_id => league.id).should_not be_empty
      player2.ratings.where(:league_id => league.id).should_not be_empty
    end

    it "updates existing ratings" do
      league = FactoryGirl.create(:league)
      player1 = FactoryGirl.create(:player)
      player2 = FactoryGirl.create(:player)
      rating1 = FactoryGirl.create(
        :rating,
        :league => league,
        :player => player1,
        :value => Rating::DefaultValue
      )
      rating2 = FactoryGirl.create(
        :rating,
        :league => league,
        :player => player2,
        :value => Rating::DefaultValue
      )

      RatingService.update(league, player1, player2)

      rating1.reload.value.should > Rating::DefaultValue
      rating2.reload.value.should < Rating::DefaultValue
    end

    it "persists the value of the pro flag" do
      league = FactoryGirl.create(:league)
      player1 = FactoryGirl.create(:player)
      player2 = FactoryGirl.create(:player)
      rating1 = FactoryGirl.create(
        :rating,
        :league => league,
        :player => player1,
        :value => Rating::DefaultValue,
        :pro => false
      )

      Rating.any_instance.stubs(:to_elo).returns(Elo::Player.new(:pro => true))

      RatingService.update(league, player1, player2)

      rating1.reload.pro?.should be_true
    end

    it "creates rating history events" do
      league = FactoryGirl.create(:league)
      player1 = FactoryGirl.create(:player)
      player2 = FactoryGirl.create(:player)
      rating1 = FactoryGirl.create(
        :rating,
        :league => league,
        :player => player1,
        :value => Rating::DefaultValue
      )
      rating2 = FactoryGirl.create(
        :rating,
        :league => league,
        :player => player2,
        :value => Rating::DefaultValue
      )

      RatingService.update(league, player1, player2)

      new_rating1 = rating1.reload.value
      new_rating2 = rating2.reload.value

      rating1.history_events.first.value.should == new_rating1
      rating2.history_events.first.value.should == new_rating2
    end
  end
end
