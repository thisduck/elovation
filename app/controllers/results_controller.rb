class ResultsController < ApplicationController
  load_and_authorize_resource :league
  load_and_authorize_resource :result, :through => :league

  def create
    raise "Create results attempt with invalid loser" unless params[:result][:loser_id].to_i == current_player.id
    response = ResultService.create(@league, params[:result])

    if response.success?
      redirect_to league_path(@league)
    else
      @result = response.result
      render :new
    end
  end

  def destroy
    result = @league.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    @result = Result.new
  end
end
