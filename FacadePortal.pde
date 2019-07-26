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
import java.util.Objects;

static final String BASE_API_URL = "http://api.openweathermap.org/data/2.5/weather?q=";
static final String API_KEY = "b9d91e04a7fe80306b4f7419d9602c26";//System.getenv("OPEN_WEATHER_MAP");
static final int WIND_THRESHOLD = 30;
static final int SUN_THRESHOLD = 2700;
AEC aec;
PFont font;

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
HashMap<String, String> skyscrapers = new HashMap();

boolean start = true;

color textColor = #FF0000;

void setup() {
  // BASIC SETUP
  colorMode(RGB);
  frameRate(25);
  size(1200, 400);
  font = createFont("FreePixel.ttf", 10, false);
  aec = new AEC();

  // POPULATE STARS, GERMAN, & SKYSCRAPERS ------------------------------------------------
  for (int i = 0; i <= 65; i++) {
    stars.add(new PVector(random(width / 4), random(height / 12)));
  }
  if (start) {
    Collections.shuffle(Arrays.asList(cities));
  }
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

  // LOAD WEATHER CONDITION FOR CITY -------------------------------------------------------
  JSONObject json = loadJSONObject(BASE_API_URL + cities[city] + "&APPID=" + API_KEY);
  weather = new Weather(json);

  int intensity = weather.intensity;
  WeatherCondition condition = null;
  Clouds clouds = new Clouds(0);
  switch (weather.mainWeather) {
  case "Clouds":
    clouds = new Clouds(weather.intensity);
  case "Clear":
    condition = new Clear();
    break;
  case "Drizzle":
    condition = new Drizzle(weather.intensity);
    clouds = new Clouds(weather.intensity);
    break;
  case "Rain":
    condition = new Rain(weather.intensity);
    clouds = new Clouds(weather.intensity);
    break;
  case "Thunderstorm":
    condition = new Thunderstorm(weather.intensity);
    clouds = new Clouds(weather.intensity);
    break;
  case "Snow":
    condition = new Snow(weather.intensity);
    clouds = new Clouds(weather.intensity);
    break;
  case "Mist":
    condition = new Mist();
    textColor = #000000;
    break;
  case "Smoke":
    condition = new Smoke();
    textColor = #000000;
    break;
  case "Haze":
    condition = new Haze();
    textColor = #000000;
    break;
  case "Dust":
    condition = new Dust();
    textColor = #000000;
    break;
  case "Fog":
    condition = new Fog();
    textColor = #000000;
    break;
  case "Sand":
    condition = new Sand();
    textColor = #000000;
    break;
  case "Ash":
    condition = new Ash();
    textColor = #000000;
    break;
  case "Squall":
    condition = new Squall();
    break;
  case "Tornado":
    condition = new Tornado();
    break;
  default:
    println("WARN: hit default on main weather switch!");
    break;
  }

  clouds = new Clouds(intensity);
  wind = new Wind(weather.windSpeed);

  // START AEC
  aec.init();
  start = false;
}

void draw() {
  aec.beginDraw();

  color cloudColor = #FFFFFF;

  //weather.mainWeather = "Mist";
  weather.mainWeather = "Clouds";
  weather.description = "overcast clouds: 85-100%";

// DRAW BACKGROUND --------------------------------------------------------------------

  long now = Instant.now().getEpochSecond();
  if (abs(now - weather.sunrise) < SUN_THRESHOLD) {
    //SUNRISE
    color c1 = #9CD6FF;
    color c2 = #9CD6FF;
    color c3 = #CEEBFF;
    color c4 = #FFFFCE;
    color c5 = #FFC78A;
    color c6 = #FFC78A;
    if (textColor == #FF0000) {
      textColor = #000000;
    }
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2, c3, c4, c5, c6);
  } else if (abs(now - weather.sunset) < SUN_THRESHOLD) {
    // SUNSET
    color c1 = color(34, 1, 78);
    color c2 = color(105, 5, 91);
    color c3 = color(142, 12, 19);
    color c4 = color(182, 75, 1);
    if (textColor == #FF0000) {
      textColor = #FFFFFF;
    }
    setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2, c3, c4);
  } else if (now < weather.sunrise || now > weather.sunset) {
    //NIGHT
    color c1 = #001639;
    color c2 = #1F007A;
    cloudColor = #DFDFDF;
    if (textColor == #FF0000) {
      textColor = #FFFFFF;
    }
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
    if (weather.intensity >= 40) {
      color c1 = #9BBED7;
      color c2 = #DCDCDC;
      cloudColor = #DFDFDF;
      if (textColor == #FF0000) {
        textColor = #000000;
      }
      setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2);
    } else {
      color c1 = #0082DB;
      color c2 = #ADDEFF;
      cloudColor = #DFDFDF;
      if (textColor == #FF0000) {
        textColor = #000000;
      }
      setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2);
    }
  } else {
    println("WARN: hit last else on sky fill!");
    background(0);
    if (textColor == #FF0000) {
      textColor = #000000;
    }
  }

// DRAW WEATHER -----------------------------------------------------------------------------------

  condition.draw();
  wind.draw();
  clouds.draw();

// DRAW TEXT --------------------------------------------------------------------------------------
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

  String city = german.get(weather.city);
  if (Objects.isNull(city)) {
    city = weather.city;
  }
  description = city + " " + convertTemp(weather.temp);

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
