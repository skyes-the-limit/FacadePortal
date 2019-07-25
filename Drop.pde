// to represent Precipitation (i.e. a ton of stuff falling from the sky)
abstract class APrecipitation implements WeatherCondition {
  ArrayList<Drop> drops;

  // generates some number of drops (of the right type) to be drawn
  void genDrops() {
    int genNum = (int)random(1, 6);
    for (int i = 0; i < genNum; i++) {
      this.drops.add(new RainDrop());
    }
  }

  // removes all drops that are offscreen
  void remDrops() {
    ArrayList<Drop> toRemove = new ArrayList<Drop>();
    for (Drop drop : drops) {
      if (drop.offCanvas()) {
        toRemove.add(drop);
      }
    }
    this.drops.removeAll(toRemove);
  }

  // draws every drop currently on screen
  void draw() {
    this.genDrops();
    for (Drop drop : drops) {
      drop.drawDrop();
      drop.update();
    }
    this.remDrops();
  }
}

class Rain extends APrecipitation {
  void draw() {
    
  }
}

class Drizzle extends APrecipitation {
  void draw() {
    
  }
}

class Thunderstorm implements WeatherCondition { 
  APrecipitation precipitation;
  
  Thunderstorm(APrecipitation precipitation) {
    this.precipitation = precipitation;
  }
  
  void draw() {
    this.precipitation.draw();
    // TODO
  }
}

class Snow extends APrecipitation {

  @Override
    void genDrops() {
    int genNum = (int)random(1, 6);
    for (int i = 0; i < genNum; i++) {
      this.drops.add(new SnowDrop());
    }
  }
}

// to represent something that's falling from the sky
interface Drop {

  //Is this drop out of bounds?
  boolean offCanvas();

  // Updates the position and velocity of this drop
  void update();

  // Draws this drop on the canvas
  void drawDrop();
}

// class to encompass some common characteristics of drops
abstract class ADrop implements Drop {
  color col;
  PVector acc;
  PVector vel;
  PVector pos;

  ADrop(color col, PVector acc, PVector vel, PVector pos) {
    colorMode(HSB, 360, 100, 100);
    this.col = col;
    this.acc = acc;
    this.vel = vel;
    this.pos = pos;
  }

  boolean offCanvas() {
    return pos.x > width || pos.y > height || pos.x < 0 || pos.y < 0;
  }

  // moves and accelerates this drop
  void update() {
    this.pos = this.pos.add(this.vel);
    this.vel = this.vel.add(this.acc);
  }

  // draws this drop
  void drawDrop() {
    fill(this.col);
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), 1, 1);
  }
}

// to represent a raindrop
class RainDrop extends ADrop {

  RainDrop() {
    super(color(random(168, 200), 100, 100), new PVector(0, random(1, 7)), new PVector(0, random(1, 5)), new PVector(random(width), 0));
  }
}

// to represent a snowflake
class SnowDrop extends ADrop {
  int[] bounds = new int[2];

  SnowDrop() {
    super(color(random(168, 200), 100, 100), new PVector(0, random(1, 7)), new PVector(0, random(1, 5)), new PVector(random(width), 0));
  }
}
