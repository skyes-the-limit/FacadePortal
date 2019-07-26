// to represent Precipitation (i.e. a ton of stuff falling from the sky)
abstract class APrecipitation implements WeatherCondition {
  ArrayList<Drop> drops;
  int density;

  APrecipitation(int dens) {
    drops = new ArrayList<Drop>();
    density = dens / 2;
  }

  // generates some number of drops (of the right type) to be drawn
  void genDrops() {
    int genNum = (int)random(max(1, density / 2), density);
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

  Rain(int intensity) {
    super(intensity);
  }
}

class Drizzle extends APrecipitation {

  Drizzle(int intensity) {
    super(round(intensity / 2));
  }
}

class Snow extends APrecipitation {

  Snow(int intensity) {
    super(intensity);
  }

  @Override
    void genDrops() {
    int genNum = (int)random(max(1, density / 2), this.density);
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

  ADrop(PVector acc, PVector vel, PVector pos, color col) {
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
    noStroke();
    fill(this.col);
    rect(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), 1, 1);
  }
}

// to represent a raindrop
class RainDrop extends ADrop implements Drop {

  RainDrop() {
    super(new PVector(0, random(3, 5)), new PVector(0, random(2, 5)), new PVector(random(width), 0), color(random(190, 205), 222, 239));
  }
}

// to represent a snowflake
class SnowDrop extends ADrop implements Drop {
  final float[] bounds = new float[2];

  SnowDrop() {
    super( new PVector(0, random(0, 1)), new PVector(1, random(1, 2)), new PVector(random(width), 0), color(random(210, 230), 227, 229));
    bounds[0] = pos.x - 4;
    bounds[1] = pos.x + 4;
  }

  @Override
    void update() {
    super.update();
    if (pos.x > bounds[1] || pos.x < bounds[0]) {
      vel.x *= -1;
    }
  }
}
