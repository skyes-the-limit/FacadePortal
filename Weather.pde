// SOURCE: https://openweathermap.org/current#current_JSON

public class Weather {
  final String city;
  final String country;
  final double latitude;
  String mainWeather;  // Rain, Snow, Extreme, etc.
  int windSpeed;       // meter/sec
  final long sunrise;        // seconds UTC
  final long sunset;         // seconds UTC
  final long dt;             // seconds UTC
  final int tz;       // shift in seconds from UTC
  final double temp;

  Weather(JSONObject json) {
    println(json.toString());

    this.city = json.getString("name");
    this.country = json.getJSONObject("sys").getString("country");
    this.latitude = json.getJSONObject("coord").getDouble("lat");
    this.mainWeather = json.getJSONArray("weather").getJSONObject(0).getString("main");
    this.windSpeed = json.getJSONObject("wind").getInt("speed");
    this.sunrise = json.getJSONObject("sys").getLong("sunrise");
    this.sunset = json.getJSONObject("sys").getLong("sunset");
    this.dt = json.getLong("dt");
    this.tz = json.getInt("timezone");
    this.temp = json.getJSONObject("main").getDouble("temp");
  }
}

/* JSON EXAMPLE:
 "coord": {"lon":-0.13,"lat":51.51},
 "weather":[{"id":300,"main":"Drizzle","description":"light intensity drizzle","icon":"09d"}],
 "base":"stations",
 "main":{"temp":280.32,"pressure":1012,"humidity":81,"temp_min":279.15,"temp_max":281.15},
 "visibility":10000,
 "wind":{"speed":4.1,"deg":80},
 "clouds":{"all":90},
 "dt":1485789600,
 "sys":{"type":1,"id":5091,"message":0.0103,"country":"GB","sunrise":1485762037,"sunset":1485794875},
 "id":2643743,
 "name":"London",
 "cod":200}
 */

interface WeatherCondition {
  void draw();
}
