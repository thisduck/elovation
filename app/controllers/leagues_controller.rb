class LeaguesController < ApplicationController
  include ParamsCleaner

  allowed_params :league => [:name]

  load_and_authorize_resource

  def create
    @league = League.new(clean_params[:league])

    if @league.save
      redirect_to league_path(@league)
    else
      render :new
    end
  end

  def destroy
    @league.destroy if @league.results.empty?
    redirect_to dashboard_path
  end

  def edit
  end

  def new
    @league = League.new
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        render :json => @league
      end
    end
  end

  def update
    if @league.update_attributes(clean_params[:league])
      redirect_to league_path(@league)
    else
      render :edit
    end
  end

  def _find_league
    @league = League.find(params[:id])
  end
end
