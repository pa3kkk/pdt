class MapController < ApplicationController
  def index
    @geojson = {}
  end

  def distance
    @geojson = PlanetOsmPoint.closes_sport(params[:range_value],params[:lat],params[:lng])
    p @geojson

    respond_to do |format|
      format.js # actually means: if the client ask for js -> return file.js
    end
  end

  def close_place
    @geojson = PlanetOsmPoint.closes_sport(params[:distance],params[:lat],params[:lng])
    p @geojson
    render json: @geojson
  end

  def sports_list
    render json: PlanetOsmPoint.get_sports
  end

end
