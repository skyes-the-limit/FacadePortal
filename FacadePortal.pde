/*
Arielle Bishop, Kriti Gurubacharya, Maggie Van Nortwick
Creative Coding - Summer 2 2019

REFERENCES:
  https://openweathermap.org/weather-conditions
  https://openweathermap.org/current#current_JSON
*/
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Arrays;

static final String BASE_API_URL = "http://api.openweathermap.org/data/2.5/weather?q=";
static final String API_KEY = "b9d91e04a7fe80306b4f7419d9602c26";//System.getenv("OPEN_WEATHER_MAP");
static final int WIND_THRESHOLD = 30;
static final int SUN_THRESHOLD = 2700;
static final AEC aec;
static final PFont font = createFont("FreePixel.ttf", 10, false);

static final float FONT_SIZE = 6;
static final float FONT_OFFSET_Y = 0.12;
static final float FONT_SCALE_X = 2.669;
static final float FONT_SCALE_Y = 2.67;

Weather weather;
WeatherCondition condition;
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

String description = "";

int city = 0;

String[] cities = new String[]{"London", "Paris", "Tokyo", "Beijing", "Seattle", "Rio de Janeiro", "Geneva",
  "Boston", "Sydney", "Buenos Aires", "Helsinki", "Barcelona", "Toronto", "Mexico City", "Dubai", "Moscow", "Istanbul",
  "Mumbai", "New Delhi", "Kathmandu", "Bangkok", "Santiago", "Lima", "Panama City", "Reykjavik", "Athens", "Marrakesh",
  "Cape Town", "Tel Aviv", "Cairo", "Nairobi", "Seoul", "Shanghai", "Lagos", "Anchorage", "Hong Kong", "Jakarta", "Auckland", "Dallas"};
  
HashMap<String, String> german = new HashMap();
  german.put("Tokyo", "Tokio");
  german.put("Beijing", "Peking");
  german.put("Geneva", "Genf");
  german.put("Mexico City", "Mexiko-Stadt");
  german.put("Moscow", "Moskau");
  german.put("New Delhi", "Neu-Delhi");
  german.put("Panama City", "Panama-Stadt");
  german.put("Reykjavik", "Reykjavík");
  german.put("Athens", "Athen");
  german.put("Marrakesh", "Marrakesch");
  german.put("Cape Town", "Kapstadt");
  german.put("Tel Aviv", "Tel Aviv-Jaffa");
  german.put("Cairo", "Kairo");
  german.put("Hong Kong", "Hongkong");
  
HashMap<String, String> skyscrapers = new HashMap();

boolean start = true;

void setup() {
  // BASIC SETUP
  colorMode(RGB);
  frameRate(25);
  size(1200, 400);
  
  // POPULATE STARS
  for (int i = 0; i <= 65; i++) {
    stars.add(new PVector(random(width / 4), random(height / 12)));
  }
  if (start) {
    Collections.shuffle(Arrays.asList(cities));
  }

  // LOAD WEATHER CONDITION FOR CITY
  JSONObject json = loadJSONObject(BASE_API_URL + cities[city] + "&APPID=" + API_KEY);
  weather = new Weather(json);

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

  // START AEC
  aec = new AEC();
  aec.init();
  start = false;
}

void draw() {
  aec.beginDraw();

  color cloudColor = #FFFFFF;
  color textColor;

// ------------------------------------- DRAW BACKGROUND -----------------------------------------------

  long now = Instant.now().getEpochSecond();
  if (abs(now - weather.sunrise) < SUN_THRESHOLD) {
    //SUNRISE
    color c1 = #9CD6FF;
    color c2 = #9CD6FF;
    color c3 = #CEEBFF;
    color c4 = #FFFFCE;
    color c5 = #FFC78A;
    color c6 = #FFC78A;
    textColor = #000000;
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2, c3, c4, c5, c6);
  } else if (abs(now - weather.sunset) < SUN_THRESHOLD) {
    // SUNSET
    color c1 = color(34, 1, 78);
    color c2 = color(105, 5, 91);
    color c3 = color(142, 12, 19);
    color c4 = color(182, 75, 1);
    textColor = #FFFFFF;
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2, c3, c4);
  } else if (now < weather.sunrise || now > weather.sunset) {
    //NIGHT
    color c1 = #081C3B;
    color c2 = #133771;
    cloudColor = #DFDFDF;
    textColor = #FFFFFF;
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2);
    for (int i = 0; i < stars.size(); i++) {
      PVector star = stars.get(i);
      noStroke();
      int alpha = 170 + round(sin(((frameCount / 5) + i) % 360) * 80);
      fill(255, alpha);
      rect(star.x, star.y, 0.7, 1);
    }
  } else if (now > weather.sunrise && now < weather.sunset) {
    // DAY
    color c1 = #2677AF;
    color c2 = #629CD5;
    cloudColor = #DFDFDF;
    textColor = #000000;
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2);
  } else {
    println("WARN: hit last else on sky fill!");
    background(0);
    textColor = #000000;
  }
  
// ------------------------------------- DRAW WEATHER ---------------------------------------------

  condition.draw();
  wind.draw();
  clouds.draw();
  
// -------------------------------------- DRAW TEXT -----------------------------------------------
  noStroke();
  fill(255, 255, 255);
  float frameInterval = 2.5;
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
  int minPos = -200;
  int maxPos = 45;
  int loopFrames = round((maxPos - minPos) * frameInterval) + 20;

  // vertical grid pos
  int yPos = 15;

  int xPos = max(minPos, maxPos - round((frameCount % loopFrames) / frameInterval));
  displayText(xPos, yPos, textColor);

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

void displayText(int x, int y, color c) {
  noStroke();
  fill(c);

  // push & translate to the text origin
  pushMatrix();
  translate(x, y + FONT_OFFSET_Y);

  // scale the font up by fixed paramteres so it fits our grid
  scale(FONT_SCALE_X, FONT_SCALE_Y);
  textFont(font);
  textSize(FONT_SIZE);

  ZoneOffset zone = ZoneOffset.ofTotalSeconds(weather.tz);
  OffsetTime time = OffsetTime.now(zone);
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
  String timeStr = time.format(formatter);
  description = weather.city + " " + convertTemp(weather.temp);

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
