import java.time.*;
import java.util.Collections;
import java.util.Arrays;

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

ArrayList<PVector> stars = new ArrayList<PVector>();

String description;

int city = 0;

String[] cities = new String[]{"London", "Paris", "Tokyo", "Beijing", "Seattle", "Rio de Janeiro", "Geneva, fr",
  "Boston", "Sydney", "Buenos Aires", "Helsinki", "Barcelona", "Toronto", "Mexico City", "Dubai", "Moscow", "Istanbul",
  "Mumbai", "New Delhi", "Kathmandu", "Bangkok", "Santiago", "Lima", "Panama City", "Reykjavik", "Athens", "Marrakesh",
  "Cape Town", "Tel Aviv", "Cairo", "Nairobi", "Seoul", "Shanghai", "Lagos", "Anchorage", "Hong Kong", "Jakarta", "Auckland", "Dallas"};

boolean start = true;

void setup() {
  for (int i = 0; i <= 300; i++) {
    stars.add(new PVector(random(width*0.4), random(height / 12)));
  }
  if (start) {
    Collections.shuffle(Arrays.asList(cities));
  }
  frameRate(25);
  size(1200, 400);
  font = createFont("FreePixel.ttf", 9, false);
  JSONObject json = loadJSONObject(BASE_API_URL + cities[city] + "&APPID=" + API_KEY);
  weather = new Weather(json);
  
  weather.mainWeather = "Clouds";

  clear = new Clear();
  clouds = new Clouds(10);
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
  start = false;
}

void draw() {
  aec.beginDraw();

  color cloudColor;
  colorMode(RGB);
  long now = Instant.now().getEpochSecond();
  if (abs(now - weather.sunrise) < SUN_THRESHOLD) {
    //SUNRISE
    color c1 = #9CD6FF;
    color c2 = #9CD6FF;
    color c3 = #CEEBFF;
    color c4 = #FFFFCE;
    color c5 = #FFC78A;
    color c6 = #FFC78A;
    cloudColor = #FFFFFF;
    setGradient(0, 0, width, height / 33, Y_AXIS, c1, c2, c3, c4, c5, c6);
  } else if (abs(now - weather.sunset) < SUN_THRESHOLD) {
    // SUNSET
    color c1 = color(114, 173, 214);
    color c2 = color(227, 121, 59);
    color c3 = color(245, 30, 38);
    cloudColor = #FFFFFF;
    setGradient(0, 0, width, height / 11, Y_AXIS, c1, c2, c3 );
  } else if (now < weather.sunrise || now > weather.sunset) {
    //NIGHT
    color c1 = color(8, 23, 66);
    color c2 = color(36, 23, 81);
    color c3 = color(20, 36, 107);
    cloudColor = #DFDFDF;
    setGradient(0, 0, width, height / 13, Y_AXIS, c1, c2, c3);
    for (PVector star : stars) {
      noStroke();
      fill(255, 190);
      rect(star.x, star.y, 0.7, 1);
    }
  } else if (now > weather.sunrise && now < weather.sunset) {
    // DAY
    color c1 = color(114, 173, 214);
    color c2 = color(177, 211, 245);
    color c3 = color(202, 231, 255);
    cloudColor = #DFDFDF;
    setGradient(0, 0, width, height / 13, Y_AXIS, c1, c2, c3);
  } else {
    println("WARN: hit last else on sky fill!");
    background(0);
    cloudColor = #DFDFDF;
  }

  // cases for main weather: https://openweathermap.org/weather-conditions
  switch(weather.mainWeather) {
  case "Clear":
    clear.draw();
    break;
  case "Clouds":
    clouds.draw(color(cloudColor, 100));
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

  wind.draw();

  noStroke();

  fill(255, 255, 255);

  float frameInterval = 2;
  // determines the speed (number of frames between text movements)
  switch(weather.mainWeather) {
    case "Mist":
    case "Smoke":
    case "Haze":
    case "Dust":
    case "Fog":
    case "Sand":
    case "Ash":
      frameInterval = 0.5;
      break;
  }

  // min and max grid positions at which the text origin should be. we scroll from max (+, right side) to min (-, left side)
  int minPos = -220;
  int maxPos = 45;
  int loopFrames = round((maxPos - minPos) * frameInterval) + 20;

  // vertical grid pos
  int yPos = 15;

  int xPos = max(minPos, maxPos - round((frameCount % loopFrames) / frameInterval));
  displayText(xPos, yPos);

  aec.endDraw();
  aec.drawSides();

  if (xPos <= minPos + 10) {
    city++;
    if (city >= cities.length) {
      city = 0;
    }
    setup();
    frameCount = 0;
  }
}

void displayText(int x, int y) {
  noStroke();
  fill(255);

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
