/*
 Arielle Bishop, Kriti Gurubacharya, Maggie Van Nortwick
 
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
static final String API_KEY = System.getenv("OPEN_WEATHER_MAP");
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

Buildings buildings;

ArrayList<PVector> stars = new ArrayList<PVector>();

String description = "";

int city = 0;

String[] cities = new String[]{"London", "Paris", "Tokyo", "Beijing", "Seattle", "Rio de Janeiro", "Geneva", 
  "Boston", "Sydney", "Buenos Aires", "Helsinki", "Barcelona", "Toronto", "Mexico City", "Dubai", "Moscow", "Istanbul", 
  "Mumbai", "New Delhi", "Kathmandu", "Bangkok", "Santiago", "Lima", "Panama City", "Reykjavik", "Athens", "Marrakesh", 
  "Cape Town", "Tel Aviv", "Cairo", "Nairobi", "Seoul", "Shanghai", "Lagos", "Anchorage", "Hong Kong", "Jakarta", "Auckland", "Dallas"};

HashMap<String, String> german = new HashMap();
HashMap<String, int[]> cityScapes = new HashMap();

color textColor = #FF0000;

void setup() {
  Collections.shuffle(Arrays.asList(cities));
  colorMode(RGB);
  frameRate(25);
  size(1200, 400);
  font = createFont("FreePixel.ttf", 10, false);
  textColor = #FF0000;
  aec = new AEC();
  aec.init();

  // POPULATE STARS, GERMAN, & CITYSCAPES ------------------------------------------------
  for (int i = 0; i <= 45; i++) {
    stars.add(new PVector(random(width / 4), random(height / 12)));
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

  cityScapes.put("London", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT} );
  cityScapes.put("Paris", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Tokyo", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT} );
  cityScapes.put("Beijing", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Seattle", new int[]{ Buildings.MED_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Rio de Janeiro", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Geneva", new int[]{ Buildings.MED_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Boston", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Sydney", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Buenos Aires", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Helsinki", new int[]{ Buildings.MED_DENS, Buildings.LOW_HEIGHT});
  cityScapes.put("Barcelona", new int[]{ Buildings.MED_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Toronto", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Mexico City", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Dubai", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Moscow", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Istanbul", new int[]{ Buildings.HIGH_DENS, Buildings.LOW_HEIGHT});
  cityScapes.put("Mumbai", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("New Delhi", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Kathmandu", new int[]{ Buildings.LOW_DENS, Buildings.LOW_HEIGHT});
  cityScapes.put("Bangkok", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Santiago", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Lima", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Panama City", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Reykjavik", new int[]{ Buildings.LOW_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Athens", new int[]{ Buildings.MED_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Marrakesh", new int[]{ Buildings.MED_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Cape Town", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Tel Aviv", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Cairo", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Nairobi", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Seoul", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Shanghai", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Lagos", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Anchorage", new int[]{ Buildings.LOW_DENS, Buildings.LOW_HEIGHT});
  cityScapes.put("Hong Kong", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Jakarta", new int[]{ Buildings.LOW_DENS, Buildings.HIGH_HEIGHT});
  cityScapes.put("Auckland", new int[]{ Buildings.HIGH_DENS, Buildings.MED_HEIGHT});
  cityScapes.put("Dallas", new int[]{ Buildings.HIGH_DENS, Buildings.HIGH_HEIGHT});
  
  reset();
}

void reset() {
  weather = null;
  city++;
  textColor = #FF0000;
  if (city >= cities.length) {
    city = 0;
  }
  frameCount = 0;
  aec = new AEC();
  aec.init();
  
  // LOAD WEATHER CONDITION FOR CITY -------------------------------------------------------
  JSONObject json = loadJSONObject(BASE_API_URL + cities[city] + "&APPID=" + API_KEY);
  while (weather == null) {
    try { 
      weather = new Weather(json);
    } catch (NullPointerException e) {
      println("NPE for city " + cities[city]);
      city++;
        if (city >= cities.length) {
          city = 0;
        }
    }
  }
  wind = new Wind(weather.windSpeed);
  clouds = new Clouds(0);
  buildings = new Buildings(cityScapes.get(weather.city));

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
}

void draw() {
  aec.beginDraw();

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
    // NIGHT
    color c1 = #001639;
    color c2 = #1F007A;
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
    if (weather.intensity >= 40) { // OVERCAST / HEAVY CLOUDS
      color c1 = #9BBED7;
      color c2 = #DCDCDC;
      textColor = #000000;
      setGradient(0, 0, width, height / 12, Y_AXIS, c1, c2);
    } else { // CLEAR
      color c1 = #0082DB;
      color c2 = #ADDEFF;
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

  buildings.draw();
  condition.draw();
  wind.draw();
  clouds.draw();

  // DRAW TEXT --------------------------------------------------------------------------------------
  noStroke();
  fill(255, 255, 255);
  float frameInterval = 5;
  // determines the speed (number of frames between text movements)
  if (Arrays.asList("Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash").contains(weather.mainWeather)) {
    frameInterval = 1;
  }
  description = city + " " + convertTemp(weather.temp);

  int minPos = - (description.length() * 8 + 80);
  int maxPos = 45;
  int loopFrames = round((maxPos - minPos) * frameInterval) + 20;
  int yPos = 15;
  int xPos = max(minPos, maxPos - round((frameCount % loopFrames) / frameInterval));
  displayText(xPos, yPos, textColor);

  aec.endDraw();
  aec.drawSides();

  // TRIGGER NEW CITY LOOP ---------------------------------------------------------------------------
  if (xPos <= minPos + 10) {
    reset();
  }
}

void displayText(int x, int y, color c) {
  noStroke();
  pushMatrix();
  fill(c);
  translate(x, y + FONT_OFFSET_Y);
  scale(FONT_SCALE_X, FONT_SCALE_Y);
  textFont(font);
  textSize(FONT_SIZE);

  String city = german.get(weather.city);
  if (Objects.isNull(city)) {
    city = weather.city;
  }
  description = city + " " + convertTemp(weather.temp);
  for (int i = 0; i < description.length(); i++) {
    if (i < description.length()) {
      text(description.charAt(i), (float) i*3, 0);
    }
  }

  popMatrix();
}

void keyPressed() {
  aec.keyPressed(key);
  switch (key) {
  case 'r':
    reset();
    break;
  }
}

int Y_AXIS = 1;
int X_AXIS = 2;

void setGradient(int x, int y, float w, float h, int axis, color ... colors) {
  noFill();
  int div = colors.length - 1;
  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (float i = y + (j*h)/div; i <= y + (j+1)*h/div; i++) {
        float inter = map(i, y + (j*h)/div, y + (j+1)*h/div, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (float i = x + (j*w/div); i <= x+(j+1)*w/div; i++) {
        float inter = map(i, x + (j*w/div), x+(j+1)*w/div, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
}

String convertTemp(double temp) {
  return (int) (temp - 273.15) + "°C";
}
