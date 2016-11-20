class MapController < ApplicationController
  def index
    @geojson = {}
  end

  def close_place
    render json: PlanetOsmPoint.get_by_distance(params[:distance],params[:lat],params[:lng])
  end

  def sports_list
    render json: PlanetOsmPoint.get_sports
  end

  def one_sport
    render json: PlanetOsmPoint.get_by_sport(params[:sport])
  end

  def save
    PlanetOsmPoint.save_sport(params[:name], params[:sport], params[:lat], params[:lng])
    p params[:name]
    p params[:sport]
    p params[:lat]
    p params[:lng]
    redirect_to root_path
  end

  def new
    @lat = params[:lat]
    @lng = params[:lng]
  end

end
