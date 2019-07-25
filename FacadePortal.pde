import java.time.*;

static final String BASE_API_URL = "http://api.openweathermap.org/data/2.5/weather?q=";
static final String API_KEY = System.getenv("OPEN_WEATHER_MAP");
static final int WIND_THRESHOLD = 30;
static final int SUN_THRESHOLD = 100;
AEC aec;
PFont font;

static final float FONT_SIZE = 6;
static final float FONT_OFFSET_Y = 0.12;
static final float FONT_SCALE_X = 2.669;
static final float FONT_SCALE_Y = 2.67;

String city = "Boston";
Weather weather;
Clear clear;
Clouds clouds;
Drizzle drizzle;
Rain rain;
Thunderstorm thunderstorm;
Snow snow;
Mist mist;
Smoke smoke;
Haze haze;
Dust dust;
Fog fog;
Sand sand;
Ash ash;
Squall squall;
Tornado tornado;
Wind wind;

String description;

ArrayList<String> cities = new ArrayList();

void setup() {
  frameRate(25);
  size(1200, 400);
  font = createFont("FreePixel.ttf", 9, false);
  JSONObject json = loadJSONObject(BASE_API_URL + city + "&APPID=" + API_KEY);
  weather = new Weather(json);

  clear = new Clear();
  clouds = new Clouds();
  drizzle = new Drizzle();
  rain = new Rain();
  thunderstorm = new Thunderstorm(rain);
  snow = new Snow();
  mist = new Mist();
  smoke = new Smoke();
  haze = new Haze();
  dust = new Dust();
  fog = new Fog();
  sand = new Sand();
  ash = new Ash();
  squall = new Squall();
  tornado = new Tornado();
  wind = new Wind(weather.windSpeed);

  aec = new AEC();
  aec.init();
  description = "";


  cities.add("London");
  cities.add("New York");
  cities.add("Paris");
  cities.add("Tokyo");
  cities.add("Beijing");
  cities.add("Seattle");
  cities.add("Rio de Janiero");
}

void draw() {
  aec.beginDraw();

  long now = Instant.now().getEpochSecond();
  if (abs(now - weather.sunrise) < SUN_THRESHOLD || abs(now - weather.sunset) < SUN_THRESHOLD) {
    // SUNSET OR SUNRISE
    color c1 = color(114, 173, 214);
    color c2 = color(227, 121, 59);
    setGradient(0, 0, width, height / 12, c1, c2, Y_AXIS);
  }
  else if (now < weather.sunrise || now > weather.sunset) {
    // NIGHT
    background(8, 23, 66);
  } else if (now > weather.sunrise && now < weather.sunset) {
    // DAY
    background(114, 173, 214);
  } else {
    background(0);
  }

  // cases for main weather: https://openweathermap.org/weather-conditions
  switch(weather.mainWeather) {
    case "Clear":
      clear.draw();
      break;
    case "Clouds":
      clouds.draw();
      break;
    case "Drizzle":
      drizzle.draw();
      break;
    case "Rain":
      rain.draw();
      break;
    case "Thunderstorm":
      thunderstorm.draw();
      break;
    case "Snow":
      snow.draw();
      break;
    case "Mist":
      mist.draw();
      break;
    case "Smoke":
      smoke.draw();
      break;
    case "Haze":
      haze.draw();
      break;
    case "Dust":
      dust.draw();
      break;
    case "Fog":
      fog.draw();
      break;
    case "Sand":
      sand.draw();
      break;
    case "Ash":
      ash.draw();
      break;
    case "Squall":
      squall.draw();
      break;
    case "Tornado":
      tornado.draw();
      break;
    default:
      println("WARN: hit default on main weather switch!");
      break;
  }

  if (weather.windSpeed > WIND_THRESHOLD) {
    wind.draw();
  }

  noStroke();

  fill(255, 255, 255);

  // determines the speed (number of frames between text movements)
  float frameInterval = 2;

  // min and max grid positions at which the text origin should be. we scroll from max (+, right side) to min (-, left side)
  int minPos = -220;
  int maxPos = 45;
  int loopFrames = round((maxPos - minPos) * frameInterval) + 20;

  // vertical grid pos
  int yPos = 15;

  displayText(max(minPos, maxPos - round((frameCount % loopFrames) / frameInterval)), yPos);

  aec.endDraw();
  aec.drawSides();
}

void displayText(int x, int y) {
  // push & translate to the text origin
  pushMatrix();
  translate(x, y + FONT_OFFSET_Y);

  // scale the font up by fixed paramteres so it fits our grid
  scale(FONT_SCALE_X, FONT_SCALE_Y);
  textFont(font);
  textSize(FONT_SIZE);

  description = weather.city + " " + convertTime(weather.dt + weather.tz) + " " + convertTemp(weather.temp) + " " + weather.mainWeather;

  // draw the font glyph by glyph, because the default kerning doesn't align with our grid
  for (int i = 0; i < description.length(); i++) {
    if (i < description.length()) {
      text(description.charAt(i), (float) i*3, 0);
    }
  }

  popMatrix();
}

void keyPressed() {
  aec.keyPressed(key);
}
