interface Drop {
  
  // Updates the position and velocity of this drop
  void update();
  
  // Draws this drop on the canvas
  void drawDrop();
}

abstract class ADrop {
  color col;
  PVector acc;
  PVector vel;
  PVector pos;

  void update() {
    this.pos = this.pos.add(this.vel);
    this.vel = this.vel.add(this.acc);
  }

  void drawDrop() {
    fill(this.col);
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), 1, 1);
  }
}


class RainDrop extends ADrop implements Drop {


  RainDrop() {
    colorMode(HSB, 360, 100, 100);
    this.pos = new PVector(random(width), 0);
    this.vel = new PVector(0, random(1, 5));
    this.acc = new PVector(0, random(1, 7));
    this.col = color(random(168, 200), 100, 100);
  }
}

class SnowDrop extends ADrop implements Drop {
  
  
}
