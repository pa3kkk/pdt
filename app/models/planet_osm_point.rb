class PlanetOsmPoint < ApplicationRecord

  self.table_name = 'planet_osm_point'

  def self.get_sport
    result = self.select('name, st_asText(st_transform(way, 4326))').where('sport = ?',"ballet").first
    p result.name
    p result.st_astext
  end

  def self.closes_sport(dist,lat,lng)
    p dist + " => this is distance"

    result = ActiveRecord::Base.connection.execute("
      SELECT sport, name, st_x(st_transform(way, 4326)) as lng, st_y(st_transform(way, 4326)) as ltd
      FROM planet_osm_point
      WHERE ST_Distance(
          ST_Transform(ST_GeomFromText('POINT(#{lng} #{lat})',4326),2163),
          ST_Transform(ST_GeomFromText(st_asText(st_transform(way, 4326)), 4326),2163)
        ) < #{dist} AND sport IS NOT NULL
    ")

    p result.count
    @geojson = []

    result.each do |point|
      # p point
      @geojson.push({
          type: 'Feature',
          geometry: {
              type: 'Point',
              coordinates: [point["lng"], point["ltd"]]
          },
          properties: {
              'marker-color': '#3ca0d3',
              'marker-size': 'large',
              'marker-symbol': 'rocket'
          }
      })
    end

    p @geojson
    return @geojson

  end

  def self.search_sport(term)
    results = self.select(:sport).where('sport ILIKE ?', "%#{term}%").group(:sport)
    p results[0].sport
    @json = []
    results.each do |result|
        @json.push({
            sport: result.sport
                   })
    end
  end

  def self.get_sports
    results = self.select(:sport).where('sport is not null').group(:sport)
    sports = []
    results.each do |result|
      sports << result.sport
    end
    sports
  end
end

