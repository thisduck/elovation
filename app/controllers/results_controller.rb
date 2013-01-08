class ResultsController < ApplicationController
  load_and_authorize_resource :league
  load_and_authorize_resource :result, :through => :league

  def create
    swap_winner_and_loser if params[:res] == 'Lost'
    response = ResultService.create(@league, current_player, params[:result])

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

  private

    def swap_winner_and_loser
      temp = params[:result][:winner_id]
      params[:result][:winner_id] = params[:result][:loser_id]
      params[:result][:loser_id] = temp
    end
end
