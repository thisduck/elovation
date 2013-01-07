class ResultsController < ApplicationController
  before_filter :_find_league

  def create
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

  def _find_league
    @league = League.find(params[:league_id])
  end
end
