public class Weather {
  final String city;
  final String country;
  final double latitude;
  String mainWeather;  // Rain, Snow, Extreme, etc.
  String description; // Intensity of weather
  int windSpeed;       // meter/sec
  final long sunrise;        // seconds UTC
  final long sunset;         // seconds UTC
  final long dt;             // seconds UTC
  final int tz;       // shift in seconds from UTC
  final double temp;
  final int intensity;

  Weather(JSONObject json) {
    this.city = json.getString("name");
    this.country = json.getJSONObject("sys").getString("country");
    this.latitude = json.getJSONObject("coord").getDouble("lat");
    this.mainWeather = json.getJSONArray("weather").getJSONObject(0).getString("main");
    this.description = json.getJSONArray("weather").getJSONObject(0).getString("description");
    this.windSpeed = json.getJSONObject("wind").getInt("speed");
    this.sunrise = json.getJSONObject("sys").getLong("sunrise");
    this.sunset = json.getJSONObject("sys").getLong("sunset");
    this.dt = json.getLong("dt");
    this.tz = json.getInt("timezone");
    this.temp = json.getJSONObject("main").getDouble("temp");
    this.intensity = parseDescription();
  }
  
  int parseDescription() {
    switch (mainWeather) {
      case "Clouds":
        switch (description) {
          case "few clouds: 11-25%":
            return 5;
          case "scattered clouds: 25-50%":
            return 12;
          case "broken clouds: 51-84%":
            return 25;
          case "overcast clouds: 85-100%":
            return 40;
          default:
            return 10;
        }
      case "Drizzle":
        switch (description) {
          case "light intensity drizzle":
            return 5;
          case "drizzle":
          case "light intensity drizzle rain":
            return 12;
          case "heavy intensity drizzle":
          case "drizzle rain":
          case "shower drizzle":
            return 25;
          case "heavy intensity drizzle rain":
          case "shower rain and drizzle":
            return 40;
          case "heavy shower rain and drizzle":
            return 60;
          default:
            return 12;
        }
      case "Rain":
        switch (description) {
          case "light rain":
          case "light intensity shower rain":
            return 5;
          case "moderate rain":
          case "freezing rain":
          case "shower rain":
          case "ragged shower rain":
            return 12;
          case "heavy intensity rain":
          case "heavy intensity shower rain":
            return 25;
          case "very heavy rain":
            return 40;
          case "extreme rain":
            return 60;
          default:
            return 12;
        }
      case "Snow":
        switch (description) {
          case "light snow":
          case "Light shower sleet":
          case "Light rain and snow":
          case "Light shower snow":
            return 5;
          case "Snow":
          case "Sleet":
          case "Shower sleet":
          case "Rain and snow":
          case "Shower snow":
            return 12;
          case "Heavy snow":
          case "Heavy shower snow":
            return 25;
          default:
            return 12;
        }
      case "Thunderstorm":
        switch (description) {
          case "thunderstorm with light rain":
          case "light thunderstorm":
          case "thunderstorm with light drizzle":
          case "thunderstorm with drizzle":
          case "thunderstorm with heavy drizzle":
            return 5;
          case "thunderstorm with rain":
          case "thunderstorm":
          case "ragged thunderstorm":
            return 12;
          case "thunderstorm with heavy rain":
          case "heavy thunderstorm":
            return 25;
          default:
            return 10;
        }
      default:
        return 0;
    }
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

class Clear implements WeatherCondition {
  void draw() {
  }
}
