import java.time.*;

private static final String BASE_API_URL = "http://api.openweathermap.org/data/2.5/weather?q=";
private static final String API_KEY = System.getenv("OPEN_WEATHER_MAP");
private static final int WIND_THRESHOLD = 30;
private static final int SUN_THRESHOLD = 300;
AEC aec;
PFont font;

private static final float FONT_SIZE = 6;
private static final float FONT_OFFSET_Y = 0.12;
private static final float FONT_SCALE_X = 2.669;
private static final float FONT_SCALE_Y = 2.67;

Weather weather;

void setup() {
  frameRate(25);
  size(1200, 400);
  font = createFont("FreePixel.ttf", 9, false);
  JSONObject json = loadJSONObject(BASE_API_URL + "London" + "&APPID=" + API_KEY);
  weather = new Weather(json);

  aec = new AEC();
  aec.init();
}

void draw() {
  aec.beginDraw();

  //long now = Instant.now().getEpochSecond();
  long now = weather.sunrise;

  if ((now - weather.sunrise) < SUN_THRESHOLD || (now - weather.sunset) < SUN_THRESHOLD) {
    // SUNSET OR SUNRISE
    color c1 = color(114, 173, 214);
    color c2 = color(250, 185, 87);
    setGradient(0, 0, width, height, c1, c2, Y_AXIS);
  }
  else if (now < weather.sunrise || now > weather.sunset) {
    // DAY
    background(114, 173, 214);
  } else if (now > weather.sunrise && now < weather.sunset) {
    // NIGHT
    background(8, 23, 66);
  }

  // cases for main weather: https://openweathermap.org/weather-conditions
  switch(weather.mainWeather) {
    case "Clear":
      new Clear().draw();
      break;
    case "Clouds":
      new Clouds().draw();
      break;
    case "Drizzle":
      new Drizzle().draw();
      break;
    case "Rain":
      new Rain().draw();
      break;
    case "Thunderstorm":
      new Thunderstorm(new Rain()).draw();
      break;
    case "Snow":
      new Snow().draw();
      break;
    case "Mist":
      new Mist().draw();
      break;
    case "Smoke":
      new Smoke().draw();
      break;
    case "Haze":
      new Haze().draw();
      break;
    case "Dust":
      new Dust().draw();
      break;
    case "Fog":
      new Fog().draw();
      break;
    case "Sand":
      new Sand().draw();
      break;
    case "Ash":
      new Ash().draw();
      break;
    case "Squall":
      new Squall().draw();
      break;
    case "Tornado":
      new Tornado().draw();
      break;
    default:
      println("WARN: hit default on main weather switch!");
      break;
  }

  if (weather.windSpeed > WIND_THRESHOLD) {
    new Wind(weather.windSpeed).draw();
  }

  noStroke();

  fill(255, 255, 255);

  // determines the speed (number of frames between text movements)
  int frameInterval = 3;

  // min and max grid positions at which the text origin should be. we scroll from max (+, right side) to min (-, left side)
  int minPos = -150;
  int maxPos = 50;
  int loopFrames = (maxPos - minPos) * frameInterval;

  // vertical grid pos
  int yPos = 15;

  displayText(max(minPos, maxPos - (frameCount % loopFrames) / frameInterval), yPos);

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

  // draw the font glyph by glyph, because the default kerning doesn't align with our grid
  for (int i = 0; i < weather.city.length(); i++)
  {
    text(weather.city.charAt(i), (float)i*3, 0);
  }

  popMatrix();
}

void keyPressed() {
  aec.keyPressed(key);
}
