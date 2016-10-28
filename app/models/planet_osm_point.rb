class PlanetOsmPoint < ApplicationRecord

  self.table_name = 'planet_osm_point'

  def self.get_by_distance(dist,lat,lng)
    results = ActiveRecord::Base.connection.execute("
      SELECT sport, name, st_x(st_transform(way, 4326)) as lng, st_y(st_transform(way, 4326)) as ltd
      FROM planet_osm_point
      WHERE ST_Distance(
          ST_Transform(ST_GeomFromText('POINT(#{lng} #{lat})',4326),2163),
          ST_Transform(ST_GeomFromText(st_asText(st_transform(way, 4326)), 4326),2163)
        ) < #{dist} AND sport IS NOT NULL
    ")

    @geojson = []

    results.each do |result|
      @geojson.push({
          type: 'Feature',
          geometry: {
              type: 'Point',
              coordinates: [result["lng"], result["ltd"]]
          },
          properties: {
              'title': result["sport"],
              'marker-color': '#3ca0d3',
              'marker-size': 'large',
              'marker-symbol': 'rocket'
          }
      })
    end
    @geojson
  end

  def self.get_by_sport(sport)
    results = ActiveRecord::Base.connection.execute("
      SELECT sport, name, st_x(st_transform(way, 4326)) as lng, st_y(st_transform(way, 4326)) as ltd
      FROM planet_osm_point
      WHERE sport = '#{sport}'
    ")

    @geojson = []

    results.each do |result|
      @geojson.push({
                        type: 'Feature',
                        geometry: {
                            type: 'Point',
                            coordinates: [result["lng"], result["ltd"]]
                        },
                        properties: {
                            title: result["name"],
                            'marker-color': '#29ef17',
                            'marker-size': 'large',
                            'marker-symbol': 'soccer'
                        }
                    })
    end
    @geojson
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

