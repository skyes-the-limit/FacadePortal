abstract class APrecipitation implements WeatherCondition {
  ArrayList<Drop> drops;

  void genDrops() {
    int genNum = (int)random(1, 6);
    for (int i = 0; i < genNum; i++) {
      this.drops.add(new SnowDrop());
    }
  }

  void remDrops() {
    ArrayList<Drop> toRemove = new ArrayList<Drop>();
    for (Drop drop : drops) {
      if (drop.offCanvas()) {
        toRemove.add(drop);
      }
    }
    this.drops.removeAll(toRemove);
  }

  void draw() {
    this.genDrops();
    for (Drop drop : drops) {
      drop.drawDrop();
    }
  }
}

class Snow extends APrecipitation {

  void genDrops() {
    int genNum = (int)random(1, 6);
    for (int i = 0; i < genNum; i++) {
      this.drops.add(new SnowDrop());
    }
  }
}

interface Drop {

  //Is this drop out of bounds?
  boolean offCanvas();

  // Updates the position and velocity of this drop
  void update();

  // Draws this drop on the canvas
  void drawDrop();
}

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

  void update() {
    this.pos = this.pos.add(this.vel);
    this.vel = this.vel.add(this.acc);
  }

  void drawDrop() {
    fill(this.col);
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), 1, 1);
  }
}


class RainDrop extends ADrop {

  RainDrop() {
    super(color(random(168, 200), 100, 100), new PVector(0, random(1, 7)), new PVector(0, random(1, 5)), new PVector(random(width), 0));
  }
}

class SnowDrop extends ADrop {
  int[] bounds = new int[2];

  SnowDrop() {
    super(color(random(168, 200), 100, 100), new PVector(0, random(1, 7)), new PVector(0, random(1, 5)), new PVector(random(width), 0));
  }
}
