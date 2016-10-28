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

end
