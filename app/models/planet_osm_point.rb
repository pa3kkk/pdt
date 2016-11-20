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

  def self.save_sport(name, sport, lng, ltd)

    # convert EPSG:4326 to EPSG:900913
    # x = lng.to_f * 20037508.34 / 180
    x = (lng.to_f * Math::PI / 180) * 6378137
    # y = Math.log(Math.tan((90 + ltd.to_f) * Math::PI / 360)) / (Math::PI / 180)*111319.490778
    # y = 180.0/Math::PI * Math.log(Math.tan(Math::PI / 4.0 + ltd.to_f * ( Math::PI / 180.0 ) / 2.0))
    y = Math.log(Math.tan(Math::PI / 4 + (ltd.to_f * Math::PI / 180) / 2)) * 6378137;

    result = ActiveRecord::Base.connection.execute("
      INSERT INTO planet_osm_point(name, sport, way)
      VALUES('#{name}','#{sport}', ST_PointFromText('POINT(#{y} #{x})', 900913));
    ")
  end

end

